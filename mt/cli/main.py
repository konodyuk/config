import click

from mt.build import build as _build
from mt.config import set_args as _set_args
from mt.log import setup_logging

set_args = click.argument(
    "variables",
    nargs=-1,
    type=click.UNPROCESSED,
    expose_value=False,
    callback=lambda ctx, value: _set_args(value),
)


@click.group()
@click.option("-v", "--verbose", "verbosity", count=True)
def main(verbosity):
    setup_logging(verbosity)


@main.command()
@click.option("--live", is_flag=True)
@click.argument(
    "path",
    type=click.Path(
        readable=True, exists=True, resolve_path=True, dir_okay=True, file_okay=False
    ),
)
@set_args
def build(path, live):
    _build(path=path, live=live)
