#!/usr/bin/env bash

set -euo pipefail

# Use GNU normal names.
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

ISAL_VERSION='2.31.0'

ISAL_URL='https://github.com/intel/isa-l.git'

ISAL_SOURCES='isal-src'
ISAL_BUILD='isal-build'
ISAL_INSTALL='isal-install'

# Create all necessary directories.
mkdir "${ISAL_INSTALL}"

ISAL_FULL_INSTALL_PATH="$(realpath ${ISAL_INSTALL})"

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
gmake -j"$(nproc --all)"
gmake install

# Go back.
popd

# Remove sources, build.
rm -rf "${ISAL_SOURCES}" "${ISAL_BUILD}"
