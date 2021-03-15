import click

from knife.group import cli_group

@cli_group.command()
def lock():
    pass

@cli_group.command()
def unlock():
    pass
