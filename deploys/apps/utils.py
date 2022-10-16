from pyinfra.operations import brew

brew.packages(
    [
        "the-unarchiver",
        "parallels",
        "hammerspoon",
    ]
)
