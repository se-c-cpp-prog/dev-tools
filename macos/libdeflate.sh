#!/usr/bin/env bash

set -euo pipefail

LIBDEFLATE_VERSION='1.21'

LIBDEFLATE_URL='https://github.com/ebiggers/libdeflate.git'

LIBDEFLATE_SOURCES='libdeflate-src'
LIBDEFLATE_BUILD='libdeflate-build'
LIBDEFLATE_INSTALL='libdeflate'

LIBDEFLATE_ZIP="macos-${LIBDEFLATE_INSTALL}-${LIBDEFLATE_VERSION}.zip"

# Download libdeflate sources.
git clone "${LIBDEFLATE_URL}" -b "v${LIBDEFLATE_VERSION}" "${LIBDEFLATE_SOURCES}"

# Set working directory to libdeflate build.
mkdir "${LIBDEFLATE_BUILD}" && pushd "${LIBDEFLATE_BUILD}"

# Build and install libdeflate.
cmake ../"${LIBDEFLATE_SOURCES}"/ -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=../"${LIBDEFLATE_INSTALL}"/ -D BUILD_SHARED_LIBS=ON
gmake -j"$(nproc --all)"
gmake install

# Go back.
popd

# Remove sources, build.
rm -rf "${LIBDEFLATE_SOURCES}" "${LIBDEFLATE_BUILD}"

# Compress installed.
zip -9 -r "${LIBDEFLATE_ZIP}" "${LIBDEFLATE_INSTALL}"

# Check compressed file.
zip --test "${LIBDEFLATE_ZIP}"
