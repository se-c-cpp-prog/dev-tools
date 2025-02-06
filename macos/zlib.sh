#!/usr/bin/env bash

set -euo pipefail

ZLIB_VERSION="${1}"

ZLIB_URL='https://github.com/madler/zlib.git'

ZLIB_SOURCES='zlib-src'
ZLIB_BUILD='zlib-build'
ZLIB_INSTALL='zlib-install'

# Download ZLIB sources.
git clone "${ZLIB_URL}" -b "v${ZLIB_VERSION}" "${ZLIB_SOURCES}"

# Set working directory to ZLIB build.
mkdir "${ZLIB_BUILD}" && pushd "${ZLIB_BUILD}"

# Build and install ZLIB.
../"${ZLIB_SOURCES}"/configure --prefix="../${ZLIB_INSTALL}/"
gmake -j"$(nproc --all)"
gmake install

# Go back.
popd

# Remove sources, build.
rm -rf "${ZLIB_SOURCES}" "${ZLIB_BUILD}"
