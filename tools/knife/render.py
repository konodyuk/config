import click
from pathlib import Path

from knife.config import Config
from knife.group import cli_group

@cli_group.command()
@click.option(
    "--config",
    "config_path",
    type=click.Path(resolve_path=True, exists=True),
    default=Path("~/config/vars").expanduser()
)
@click.option("--override", type=str)
@click.argument(
    "template",
    type=click.Path(
        resolve_path=True,
        exists=True,
        dir_okay=False,
    )
)
def render(config_path, template, override=None):
    config = Config.from_path(config_path)
    if override:
        config.set_override(override)
    config.render(template)
