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
@click.argument(
    "template",
    type=click.Path(
        resolve_path=True,
        exists=True,
        dir_okay=False,
    )
)
def render(config_path, template):
    config = Config.from_path(config_path)
    config.render(template)

@cli.command()
def lock():
    pass

@cli.command()
def unlock():
    pass

if __name__ == "__main__":
    cli()
