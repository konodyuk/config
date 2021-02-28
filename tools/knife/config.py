import os
from pathlib import Path

import attr
from box import Box
from jinja2 import Template

@attr.s
class Config:
    data = attr.ib(type=Box)

    @classmethod
    def from_file(cls, path):
        data = Box.from_yaml(filename=path)
        return cls(data)

    @classmethod
    def from_dir(cls, path):
        data = _recursively_read_yaml(path)
        return cls(data)

    @classmethod
    def from_path(cls, path):
        path = Path(path).resolve()
        if path.is_dir():
            return cls.from_dir(path)
        elif path.is_file():
            return cls.from_file(path)
        raise UserWarning()

    def set_override(self, mode):
        if mode not in self.data.overrides:
            raise UserWarning(f"No override {mode} specified")
        self.data.merge_update(self.data.overrides[mode])

    def render(self, path):
        path = Path(path).resolve()
        assert path.name.endswith(".j2")
        out_path = path.parent / path.name[:-3]
        with open(path, "r") as f:
            template = Template(f.read())
        result = template.render(self.data)
        with open(out_path, "w") as f:
            f.write(result)

def _recursively_read_yaml(path):
    path = Path(path).resolve()
    result = Box()
    for filename in os.listdir(path):
        filepath = (path / filename)
        extension = str(filepath).rpartition(".")[-1]
        if filepath.is_file() and extension in ["yml", "yaml"]:
            yaml = Box.from_yaml(filename=filepath)
        elif filepath.is_dir():
            yaml = Box({filename: _recursively_read_yaml(filepath)})
        result.merge_update(yaml)
    return result
