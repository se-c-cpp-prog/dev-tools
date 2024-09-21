#!/usr/bin/env bash

set -euo pipefail

LIBDEFLATE_VERSION='1.21'

LIBDEFLATE_URL='https://github.com/ebiggers/libdeflate.git'

LIBDEFLATE_SOURCES='libdeflate-src'
LIBDEFLATE_BUILD='libdeflate-build'
LIBDEFLATE_INSTALL='libdeflate-install'

# Download libdeflate sources.
git clone "${LIBDEFLATE_URL}" -b "v${LIBDEFLATE_VERSION}" "${LIBDEFLATE_SOURCES}"

# Set working directory to libdeflate build.
mkdir "${LIBDEFLATE_BUILD}" && pushd "${LIBDEFLATE_BUILD}"

# Build and install libdeflate.
cmake ../"${LIBDEFLATE_SOURCES}"/ -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=../"${LIBDEFLATE_INSTALL}"/ -D BUILD_SHARED_LIBS=ON
make -j"$(nproc --all)"
make install

# Go back.
popd

# Remove sources, build.
rm -rf "${LIBDEFLATE_SOURCES}" "${LIBDEFLATE_BUILD}"
