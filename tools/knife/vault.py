import os
import json
import webbrowser
import subprocess
from pathlib import Path
from urllib.parse import quote

import click

from knife.group import cli_group

def _list_vaults(path, max_depth=2):
    path = Path(path)
    result = list()
    for depth in range(max_depth):
        for vault in path.glob(depth * "*/" + "*-vault"):
            result.append(str(vault.relative_to(path)))
    return result

def _fuzzy_choose(options, query=None):
    from iterfzf import iterfzf
    return iterfzf(options, query=query)

def _open_vault(vault_name):
    if vault_name is None:
        return
    _, _, vault_name = vault_name.rpartition("/")
    vault_name = quote(vault_name, safe="")
    url = f"obsidian://open?vault={vault_name}"
    webbrowser.open(url)

def _create_vaults(names, vaults_dir):
    vault_dirs = [str(Path(vaults_dir) / name) for name in names]
    args = [
        'ansible-playbook',
        str(Path('~/config/playbook.yml').expanduser()),
        '--tags',
        'obsidian',
        '--skip-tags',
        'obsidian_main_vaults',
        '--extra-vars',
        json.dumps({"vaults": {"additional": vault_dirs}}),
    ]
    subprocess.run(args, stdout=subprocess.PIPE)

@cli_group.command()
@click.option("--new", is_flag=True)
@click.option("-l", "--list", "show_list", is_flag=True)
@click.option(
    "--vaults_dir",
    type=click.Path(resolve_path=True, exists=True),
    default=Path("~/Documents/vaults").expanduser()
)
@click.argument("names", nargs=-1)
def vault(names, new, show_list, vaults_dir):
    if new:
        _create_vaults(names, vaults_dir)
        return
    if show_list:
        print("\n".join(_list_vaults(vaults_dir)))
        return
    available_vaults = _list_vaults(vaults_dir)
    if len(names) == 0:
        _open_vault(_fuzzy_choose(available_vaults))
    for search_name in names:
        matches = []
        for vault_name in available_vaults:
            if vault_name.find(search_name) != -1:
                matches.append(vault_name)
        if len(matches) == 1:
            _open_vault(matches[0])
        else:
            _open_vault(_fuzzy_choose(available_vaults, query=search_name))