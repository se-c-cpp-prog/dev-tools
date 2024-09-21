#!/usr/bin/env bash

set -euo pipefail

LIBPNG_VERSION='1.6.43'

LIBPNG_URL='https://download.sourceforge.net/libpng'

LIBPNG_SOURCES="libpng-${LIBPNG_VERSION}"
LIBPNG_DOWNLOADED_ARCHIVE="${LIBPNG_SOURCES}.tar.gz"
LIBPNG_BUILD='libpng-build'
LIBPNG_INSTALL='libpng-install'

# Create all necessary directories.
mkdir "${LIBPNG_INSTALL}"

LIBPNG_FULL_INSTALL_PATH="$(realpath ${LIBPNG_INSTALL})"

# Download and extract libpng sources.
wget "${LIBPNG_URL}/${LIBPNG_DOWNLOADED_ARCHIVE}"
tar -xf "${LIBPNG_DOWNLOADED_ARCHIVE}"
rm "${LIBPNG_DOWNLOADED_ARCHIVE}"

# Set working directory to libpng build.
mkdir "${LIBPNG_BUILD}" && pushd "${LIBPNG_BUILD}"

# Build and install libpng.
../"${LIBPNG_SOURCES}"/configure --prefix="${LIBPNG_FULL_INSTALL_PATH}" --enable-shared=yes --enable-static=no
gmake -j"$(nproc --all)"
gmake install

# Go back.
popd

# Remove sources, build.
rm -rf "${LIBPNG_SOURCES}" "${LIBPNG_BUILD}"
