# install & setup starship & shell utilities

from pyinfra.operations import brew, pip

brew.packages(
    [
        "starship",
        "zoxide",
        "fzf",
        "ripgrep",
        "gitui",
        "bat",
        "neovim",
        "watch",
        "tmux",
        "tldr",
    ]
)

pip.packages(
    packages=[
        "click",
        "ipython",
        "black",
        "isort",
        "ruamel.yaml",
    ],
    pip="pip3",
)
