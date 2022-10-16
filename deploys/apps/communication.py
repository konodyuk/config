from pyinfra.operations import brew

brew.packages(
    [
        "telegram",
        "zoom",
    ]
)
