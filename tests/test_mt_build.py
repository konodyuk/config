import attr

from mt.build import Build


@attr.s
class CallRecorder:
    key = attr.ib()
    callback = attr.ib()

    def __call__(self):
        if self.callback:
            self.callback(self.key)


def simulate_tree(tree, on_run_callback, build_object=None):
    if build_object is None:
        build_object = Build()
    build = build_object
    for key in tree:
        deps = tree[key]
        if isinstance(deps, dict):
            dep_names = list(deps.keys())
        elif isinstance(deps, list):
            dep_names = deps
        else:
            raise UserWarning("incorrect tree")

        build(target=key, deps=dep_names)(CallRecorder(key, on_run_callback))

        if isinstance(deps, dict):
            simulate_tree(
                tree=deps, on_run_callback=on_run_callback, build_object=build_object
            )

    return build_object


def test_add_node():
    build = Build()

    @build(
        target="one",
        deps=["two", "three"],
    )
    def f():
        print("one")

    tree = build.tree
    node = tree["one"]
    assert len(tree) == 3
    assert len(node.successors) == 0
    assert len(node.predecessors) == 2


def test_run():
    call_stack = []

    build = simulate_tree(
        {
            "one": {"two": {}, "three": {"four": ["five", "six"]}},
        },
        on_run_callback=call_stack.append,
    )

    build.tree.run_all()

    assert len(call_stack) == 4
    assert set(call_stack) == {"one", "two", "three", "four"}


def test_execution_order():
    call_stack = []

    build = simulate_tree(
        {
            "one": {"two": {"three": {"four": ["five", "six"]}}},
        },
        on_run_callback=call_stack.append,
    )

    build.tree.run_all()

    assert len(call_stack) == 4
    assert call_stack == ["four", "three", "two", "one"]


def test_addition_order_invariance():
    call_stack_one = []
    call_stack_two = []

    build_one = simulate_tree(
        {
            "a": {
                "b": ["c"],
            },
            "d": {
                "e": {"f": []},
                "g": {
                    "h": [],
                    "i": ["j", "k"],
                },
            },
        },
        on_run_callback=call_stack_one.append,
    )

    build_two = simulate_tree(
        {
            "d": {
                "g": {
                    "h": [],
                    "i": ["j", "k"],
                },
                "e": {"f": []},
            },
            "a": {
                "b": ["c"],
            },
        },
        on_run_callback=call_stack_two.append,
    )

    nodes_one = set()
    for key, node in build_one.tree.items():
        nodes_one.add(
            (
                key,
                node.target,
                frozenset(dep.target for dep in node.predecessors),
            )
        )

    nodes_two = set()
    for key, node in build_two.tree.items():
        nodes_two.add(
            (
                key,
                node.target,
                frozenset(dep.target for dep in node.predecessors),
            )
        )

    assert nodes_one == nodes_two


def test_multiple_targets():
    call_stack = []

    build = simulate_tree(
        {
            "one": {"two": {"three": {"four": ["five", "six"]}}},
            "seven": {"eight": ["three", "four"]},
        },
        on_run_callback=call_stack.append,
    )

    build.tree.run_all()

    assert len(call_stack) == 6
    assert set(call_stack) == {"one", "two", "three", "four", "seven", "eight"}


def test_run_forward():
    call_stack = []

    build = simulate_tree(
        {
            "one": {"two": {"three": {"four": ["five", "six"]}}},
            "seven": {"eight": ["three", "four"]},
        },
        on_run_callback=call_stack.append,
    )

    build.tree.run_forward("three")

    assert len(call_stack) == 4
    assert set(call_stack) == {"one", "two", "seven", "eight"}

    call_stack = []

    build = simulate_tree(
        {
            "one": {"two": {"three": {"four": ["five", "six"]}}},
            "seven": {"eight": ["three", "four"]},
        },
        on_run_callback=call_stack.append,
    )

    build.tree.run_forward("four")

    assert len(call_stack) == 5
    assert set(call_stack) == {"one", "two", "three", "seven", "eight"}
