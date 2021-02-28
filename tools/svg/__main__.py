import click

@click.group()
def cli():
    pass

option_dark = click.option("--dark", is_flag=True)
argument_file = click.argument(
    "file",
    type=click.Path(
        file_okay=True,
        dir_okay=False,
        resolve_path=True
    )
)

@cli.command()
@click.option("--template", type=click.Choice([1, 2, 3]))
@option_dark
@argument_file
def open(file, template=None, dark=False):
    print(file, type(file))

@cli.command()
@click.option("--to", type=click.Choice(["md", "svg", "tex"]))
@option_dark
@argument_file
def convert(file, dark=False, to=None):
    pass

if __name__ == "__main__":
    cli()
