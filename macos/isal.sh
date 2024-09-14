#!/usr/bin/env bash

set -euo pipefail

ISAL_VERSION='2.31.0'

ISAL_URL='https://github.com/intel/isa-l.git'

ISAL_SOURCES='isal-src'
ISAL_BUILD='isal-build'
ISAL_INSTALL='isal'
ISAL_FULL_INSTALL_PATH="$(realpath ${ISAL_INSTALL})"

ISAL_TAR="macos-${ISAL_INSTALL}-${ISAL_VERSION}.tar.gz"

# Download isa-l sources.
git clone "${ISAL_URL}" -b "v${ISAL_VERSION}" "${ISAL_SOURCES}"

# Set working directory to isa-l sources.
pushd "${ISAL_SOURCES}"

# Autogen.
./autogen.sh

# Go back.
popd

# Set working directory to isa-l build.
mkdir "${ISAL_BUILD}" && pushd "${ISAL_BUILD}"

# Build and install isa-l.
../"${ISAL_SOURCES}"/configure --prefix="${ISAL_FULL_INSTALL_PATH}" --enable-shared=yes --enable-static=no
make -j"$(nproc --all)"
make install

# Go back.
popd

# Remove sources, build.
rm -rf "${ISAL_SOURCES}" "${ISAL_BUILD}"

# Compress installed.
export GZIP=-9
tar cvzf "${ISAL_TAR}" "${ISAL_INSTALL}"

# Check compressed file.
tar -tf "${ISAL_TAR}"
