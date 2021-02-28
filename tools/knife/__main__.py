import click
from knife.config import Config

@click.group()
def cli():
    pass

@cli.command()
@click.option(
    "--config",
    "config_path",
    type=click.Path(resolve_path=True, exists=True)
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

@cli.command()
def lock():
    pass

@cli.command()
def unlock():
    pass

if __name__ == "__main__":
    cli()
