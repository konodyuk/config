import os

import click

from knife.index import COMMANDS

module_dir = os.path.dirname(__file__)

class LazyAliasedGroup(click.Group):
    def list_commands(self, ctx):
        return sum(COMMANDS.values(), [])

    def get_command(self, ctx, cmd_name):
        matches = list()
        for filename, commands in COMMANDS.items():
            for command in commands:
                if command.startswith(cmd_name):
                    matches.append({"command": command, "filename": filename})
        if not matches:
            return None
        elif len(matches) == 1:
            return self._load_command(cmd_name=matches[0]["command"], filename=matches[0]["filename"])
        ctx.fail('Too many matches: %s' % ', '.join(sorted(matches)))

    def _load_command(self, cmd_name, filename):
        namespace = dict()
        filepath = os.path.join(module_dir, filename)
        with open(filepath) as f:
            code = compile(f.read(), filepath, 'exec')
            eval(code, namespace, namespace)
        return namespace[cmd_name]

@click.group(cls=LazyAliasedGroup)
def cli_group():
    pass
