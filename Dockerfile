#
# This image is to provide us with a stable, old platform to build our
# pypi wheels with so we don't rely on newer glibc or other dependencies.
#
# Build this with:
#     docker build . -t mwatelescope/maturin:latest
#
# Run this with: 
#     docker run -it --rm -v $(pwd)/../..:/io mwatelescope/maturin:latest
#
# The following use mwalib as an example:
#
# Once at the prompt, build with:
#     maturin build --release --features "python,cfitsio-static,examples" --strip --manylinux 2014
#
# Publish to the test pypi repository first, with (where PYPI_TOKEN is a token generated from https://test.pypi.org):
#     maturin publish --features "python,cfitsio-static,examples" --manylinux 2014 --username __token__ --password PYPI_TOKEN --repository-url https://test.pypi.org/legacy/
#
# Publish to the real pypi repository, with (where USERNAME and PASSWORD are valid):
#     maturin publish --features "python,cfitsio-static,examples" --manylinux 2014 --username USERNAME --password PASSWORD
#
# x86_64 base
FROM quay.io/pypa/manylinux2014_x86_64 as base-amd64
# x86_64 builder
FROM --platform=$BUILDPLATFORM ghcr.io/rust-cross/rust-musl-cross:x86_64-musl as builder-amd64

ARG TARGETARCH
FROM builder-$TARGETARCH as builder

FROM base-$TARGETARCH

ENV PATH /root/.cargo/bin:$PATH

ENV PATH /opt/python/cp38-cp38/bin:/opt/python/cp39-cp39/bin:/opt/python/cp310-cp310/bin:/opt/python/cp311-cp311/bin:/opt/python/cp312-cp312/bin:$PATH

ENV USER root

RUN curl --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && yum install -y libffi-devel openssh-clients \
    && python3.8 -m pip install --no-cache-dir cffi \
    && python3.9 -m pip install --no-cache-dir cffi \
    && python3.10 -m pip install --no-cache-dir cffi \
    && python3.11 -m pip install --no-cache-dir cffi \
    && python3.12 -m pip install --no-cache-dir cffi \
    && mkdir /io

WORKDIR /io

RUN rustup install 1.63 --no-self-update

RUN rustup default 1.63

RUN rm -rf /io/target

# Update maturin
RUN pip install -U maturin

ENTRYPOINT ["/bin/bash"]
