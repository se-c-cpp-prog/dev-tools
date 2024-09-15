#!/usr/bin/env bash

set -euo pipefail

ZLIB_VERSION='1.3.1'

ZLIB_URL='https://github.com/madler/zlib.git'

ZLIB_SOURCES='zlib-src'
ZLIB_BUILD='zlib-build'
ZLIB_INSTALL='zlib'

ZLIB_TAR="ubuntu-${ZLIB_INSTALL}-${ZLIB_VERSION}.tar.gz"

# Download ZLIB sources.
git clone "${ZLIB_URL}" -b "v${ZLIB_VERSION}" "${ZLIB_SOURCES}"

# Set working directory to ZLIB build.
mkdir "${ZLIB_BUILD}" && pushd "${ZLIB_BUILD}"

# Build and install ZLIB.
../"${ZLIB_SOURCES}"/configure --prefix="../${ZLIB_INSTALL}/"
make -j"$(nproc --all)"
make install

# Go back.
popd

# Remove sources, build.
rm -rf "${ZLIB_SOURCES}" "${ZLIB_BUILD}"

# Compress installed.
export GZIP=-9
tar cvzf "${ZLIB_TAR}" "${ZLIB_INSTALL}"

# Check compressed file.
tar -tf "${ZLIB_TAR}"
