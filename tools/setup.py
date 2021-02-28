import setuptools

setuptools.setup(
    name="konodyuk-tool-suite",
    version="0.0.1",
    packages=setuptools.find_packages(),
    entry_points={
        "console_scripts": [
            "knife=knife.__main__:cli",
            "svg=svg.__main__:cli",
        ]
    },
)
