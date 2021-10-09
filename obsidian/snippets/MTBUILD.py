import base64
import shutil
from functools import partial
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

from mt.build import Build
from mt.config import cfg

build = Build()

jinja_env = Environment(loader=FileSystemLoader("."))

FONTS = [
    "FiraCode-Medium.woff2",
    "fa-regular-400.woff2",
    "fa-brands-400.woff2",
    "fa-solid-900.woff2",
    "fa-duotone-900.woff2",
    "fa-thin-100.woff2",
    "fa-light-300.woff2",
]
FONT_FILES = [f"fonts/{i}" for i in FONTS]
FONT_OUTPUTS = [f"base64/{i}.b64" for i in FONTS]


@build(
    target="styles.css",
    deps=[
        "styles.css.j2",
        "_variables.css.j2",
        "_highlighting.css",
        "_lists.css",
        "_embeds.css",
        "_fonts.css.j2",
    ],
)
def build_styles():
    template = jinja_env.get_template("styles.css.j2")
    with open("styles.css", "w") as f:
        f.write(template.render(cfg))


def b64encode(file_in, file_out):
    with open(file_in, "rb") as f:
        out = base64.b64encode(f.read())
    with open(file_out, "wb") as f_out:
        f_out.write(out)


for font_in, font_out in zip(FONT_FILES, FONT_OUTPUTS):
    build(target=font_out, deps=[font_in])(
        partial(b64encode, file_in=font_in, file_out=font_out)
    )


@build(target="_output_file", deps=["styles.css"])
def copy_to_vault():
    vault_path = cfg.args.get("vault", None)
    if vault_path is None:
        return

    vault_path = Path(vault_path)
    if vault_path.name != "styles":
        vault_path = vault_path / "styles.css"

    print("Copying to", vault_path)
    shutil.copyfile("styles.css", vault_path)
