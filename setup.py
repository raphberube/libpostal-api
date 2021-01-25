from setuptools import setup

setup(
    name='libpostal-api',
    version='0.1',
    description='Quick date functions for my location',
    url='https://github.com/raphberube/libpostal-api',
    author='raphberube',
    author_email='raphael.berube@telus.com',
    license='GNU GPLv3',
    install_requires=[
        'flask','postal'
    ],
    zip_safe=False)
