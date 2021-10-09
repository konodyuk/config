import os
from pathlib import Path

from omegaconf import OmegaConf


def _find_root_dir():
    result = Path(__file__).resolve()
    while not result.name == "config":
        result = result.parent
    return result


PWD = _find_root_dir()


def _config_from_dir(path: Path) -> dict:
    path = path.resolve()
    result = OmegaConf.create()
    for file_name in os.listdir(path):
        file_path = path / file_name
        file_contents = None
        if file_path.is_file():
            group_name, _, extension = file_name.rpartition(".")
            if extension in ["yml", "yaml"]:
                file_contents = OmegaConf.load(file_path)
        elif file_path.is_dir():
            group_name = file_name
            file_contents = _config_from_dir(file_path)
        if file_contents:
            # can potentially use `.unsafe_merge` for better performance
            result = OmegaConf.merge(result, {group_name: file_contents})
    return result


# Can create a schema class Config and annotate cfg with it
# In order to validate the schema, can first create a structured config:
# `cfg = OmegaConf.structured(Config)`
# and then merge it with the newly read:
# `cfg = OmegaConf.merge(cfg, _read_conf())`
cfg = _config_from_dir(PWD / "vars")
cfg.args = {}


def set_args(args):
    cfg.args = OmegaConf.from_cli(args)
