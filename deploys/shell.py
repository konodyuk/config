# install & setup starship & shell utilities
# @TODO: install oh-my-zsh

from pyinfra.operations import brew

brew.packages(["starship", "zoxide"])
