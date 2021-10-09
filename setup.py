import setuptools

setuptools.setup(
    name="mt",
    version="0.0.1",
    author="Nikita Konodyuk",
    author_email="konodyuk@gmail.com",
    description="Monotool",
    packages=setuptools.find_packages(include="mt*"),
    install_requires=[
        "attrs",
        "click",
        "jinja2",
        "omegaconf",
        "pyinfra",
        "watchgod",
    ],
    entry_points={
        "console_scripts": [
            "mt=mt.cli.main:main",
        ]
    },
)
