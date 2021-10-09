import setuptools

setuptools.setup(
    name="mt",
    version="0.0.1",
    author="Nikita Konodyuk",
    author_email="konodyuk@gmail.com",
    description="Monotool",
    packages=setuptools.find_packages(include="mt*"),
    install_requires=[],
    entry_points={
        "console_scripts": [
            "mt=mt.cli.main:main",
        ]
    },
)
