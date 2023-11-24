# maturin

## Introduction

An anylinux 2014 x86_64 docker image which allows for publishing a maximumly compatible python wheels.

* You will find all the current support versions of python in `/opt/python`.
* Latest version of maturin is installed
* Latest rust is installed
* rust 1.63 is also installed (and set to default)

Currently this image is used by [mwalib](https://github.com/MWATelescope/mwalib)

## How to Build

```bash
docker build . -t mwatelescope/maturin:latest
```

## How to Use

```bash
docker run -it --rm -v $(pwd)/../..:/io mwatelescope/maturin:latest
```

## How to push to dockerhub

```bash
docker push mwatelescope/maturin:latest
```
