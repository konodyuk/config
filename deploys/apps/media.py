from pyinfra.operations import brew

brew.packages(
    [
        "spotify",
        "elmedia-player",
    ]
)
