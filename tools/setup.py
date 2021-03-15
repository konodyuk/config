import setuptools

setuptools.setup(
    name="konodyuk-tool-suite",
    version="0.0.1",
    packages=setuptools.find_packages(),
    install_requires=[
        "attrs==20.3.0",
        "python-box==5.2.0",
        "click==7.1.2",
        "iterfzf==0.5.0.20.0",
        "jinja2",
    ],
    entry_points={
        "console_scripts": [
            "knife=knife.__main__:main",
            "k=knife.__main__:main",
            "svg=svg.__main__:cli",
        ]
    },
)
