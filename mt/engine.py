import typing as t
from functools import wraps

import click
from pyinfra import logger
from pyinfra.api import Config, Inventory, State
from pyinfra.api.connect import connect_all
from pyinfra.api.exceptions import PyinfraError
from pyinfra.api.operations import run_ops

from mt.config import cfg
from mt.log import setup_logging

setup_logging(0)

STATE: t.Optional[State] = None
TASKS: t.Dict[str, t.Callable] = dict()
BUNDLES: t.Dict[str, t.Callable] = dict()


def _create_state():
    inv = Inventory(([("@local", {})], {}))
    st = State(inv, Config())
    connect_all(st)
    return st


def task(name: t.Optional[str] = None):
    def wrapper(func):
        if name is None:
            task_name = func.__name__
        else:
            task_name = name

        @wraps(func)
        def _inner(*args, **kwargs):
            global STATE

            is_outermost_call = STATE is None

            if is_outermost_call:
                STATE = _create_state()

            try:
                try:
                    if cfg.verbosity > 0:
                        click.echo(
                            "{0} {1}".format(
                                click.style(f"--> Starting task:", "blue", bold=True),
                                click.style(task_name, bold=True),
                            )
                        )
                    result = func(*args, **kwargs)
                except PyinfraError as e:
                    if "API operation called without state/host" in str(e):
                        raise UserWarning(
                            "No keywords provided. Add `**kw()` to function call. Example: `files.directory('path', **kw())`"
                        )
                    else:
                        raise e
                if is_outermost_call:
                    run_ops(STATE)
            finally:
                if is_outermost_call:
                    STATE = None

        assert task_name not in TASKS, f"Task already exists: {task_name}"
        TASKS[task_name] = _inner

        return _inner

    return wrapper


def kw():
    assert (
        STATE is not None
    ), "Attempted to use pyinfra operation out of @task() environment"
    return {
        "state": STATE,
        "host": STATE.inventory.hosts["@local"],
        "_op_order_number": len(STATE.op_meta),
    }
