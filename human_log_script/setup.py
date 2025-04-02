from setuptools import setup

setup(
    name="obsidian-logger",
    version="0.1",
    py_modules=["timestamp_logger"],
    entry_points={
        'console_scripts': [
            'log=timestamp_logger:main',
        ],
    },
)