# link self to global config dir
import os
from pathlib import Path

from pyinfra.operations import files

# /config/deploys/init.py -> /config/deploys -> /config
# @TODO: locate .git
CONF_ROOT = Path(__file__).parent.parent

files.link(
    name="Link config repo to global ~/config dir",
    path=os.path.expanduser("~/config"),
    target=str(CONF_ROOT.resolve()),
)
