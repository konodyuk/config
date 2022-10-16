# install vscode & TODO: vscode extensions
from pyinfra.operations import brew

brew.packages(
    [
        "visual-studio-code",
        "sublime-text",
    ]
)
