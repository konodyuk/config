import click

from mt.build import build as _build
from mt.log import setup_logging


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
def build(path, live):
    _build(path=path, live=live)
