#!/usr/bin/env python
import os
from setuptools import setup, find_packages

setup(
    name='AirscriptUI',
    version='0.0.1',
    author='Jeff Lindsay',
    author_email='progrium@gmail.com',
    description='Web frontend for Airscript',
    license='MIT',
    classifiers=[
        "Topic :: Utilities",
        "License :: OSI Approved :: MIT License",
    ],
    url="http://github.com/airscript/airscript.io",
    packages=find_packages(),
    install_requires=['Flask', 'flask-restful'],
)

