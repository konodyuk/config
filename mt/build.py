import os
from pathlib import Path
from typing import Callable, List

import attr
import watchgod

BUILD_SCRIPT_NAME = "MTBUILD.py"


@attr.s(hash=False)
class BuildTreeNode:
    target = attr.ib(type=str, default=None)
    predecessors = attr.ib(type=set, factory=set)
    successors = attr.ib(type=set, factory=set)
    function = attr.ib(type=Callable, default=None)
    live_only = attr.ib(type=bool, default=False)
    _run_id = attr.ib(init=False, default=None, cmp=False)

    def run_backward(self, run_id=None):
        if run_id is self._run_id:
            return
        for node in self.predecessors:
            node.run_backward(run_id=run_id)
        if self.function is not None:
            print("Building", self.target)
            self.function()
        if run_id is not None:
            self._run_id = run_id

    def run_forward(self, run_self=False, run_id=None, is_live_run=False):
        if not is_live_run and self.live_only:
            return
        if self.function is not None and run_self:
            if run_id is not None:
                if run_id != self._run_id:
                    print("Building", self.target)
                    self.function()
                    self._run_id = run_id
            else:
                print("Building", self.target)
                self.function()
        for node in self.successors:
            node.run_forward(run_self=True, run_id=run_id)

    def __hash__(self):
        return hash(self.target)


class BuildTree(dict):
    def __getitem__(self, key: str):
        node = self.get(key, None)
        if node is None:
            node = BuildTreeNode(target=key)
            self[key] = node
        return node

    def add_node(self, target: str, deps: List[str], func: Callable, live_only: bool):
        node = self[target]
        assert node.function is None, f"Duplicate target: {target}"

        node.function = func
        node.live_only = live_only

        for dep in deps:
            dep_node = self[dep]
            node.predecessors.add(dep_node)
            dep_node.successors.add(node)

    def run_all(self):
        run_id = object()
        for node in self.values():
            node.run_backward(run_id=run_id)

    def run_forward(self, target: str, is_live_run: bool = False):
        run_id = object()
        self[target].run_forward(run_self=False, run_id=run_id, is_live_run=is_live_run)


class Build:
    def __init__(self):
        self.tree = BuildTree()

    def __call__(self, target: str, deps: List[str] = None, live_only: bool = False):
        if deps is None:
            deps = []

        def _inner(func):
            self.tree.add_node(target=target, deps=deps, func=func, live_only=live_only)

        return _inner

    def run(self):
        self.tree.run_all()

    def on_file_update(self, file: str):
        if file in self.tree:
            self.tree.run_forward(file, is_live_run=True)


def build(path: str, live: bool = False):
    path = Path(path).expanduser().resolve()

    if not (path / BUILD_SCRIPT_NAME).exists():
        raise UserWarning("Missing file:", BUILD_SCRIPT_NAME)

    os.chdir(path)
    try:
        build = _load_build(path)
        build.run()
    except Exception as e:
        print(f"Error loading/executing {BUILD_SCRIPT_NAME}:", e)

    if not live:
        return

    for changes in watchgod.watch(path):
        for _, filepath in changes:
            print("File changed:", filepath)
            filepath = Path(filepath).expanduser().resolve()

            if filepath.name == BUILD_SCRIPT_NAME:
                try:
                    build = _load_build(path)
                    build.run()
                except Exception as e:
                    print(f"Error loading/executing {BUILD_SCRIPT_NAME}:", e)
            else:
                filepath_rel = str(filepath.relative_to(path))
                try:
                    build.on_file_update(filepath_rel)
                except Exception as e:
                    print(f"Error building {filepath_rel}:", e)


def _load_build(path) -> Build:
    ns = dict()
    with open(path / BUILD_SCRIPT_NAME, "r") as f:
        exec(f.read(), ns)
    build = ns.get("build", None)
    if build is None:
        raise UserWarning("Missing global variable: build")
    return build
