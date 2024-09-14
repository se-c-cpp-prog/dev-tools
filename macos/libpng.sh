#!/usr/bin/env bash

set -euo pipefail

LIBPNG_VERSION='1.6.43'

LIBPNG_URL='https://download.sourceforge.net/libpng'

LIBPNG_SOURCES="libpng-${LIBPNG_VERSION}"
LIBPNG_DOWNLOADED_ARCHIVE="${LIBPNG_SOURCES}.tar.gz"
LIBPNG_BUILD='libpng-build'
LIBPNG_INSTALL='libpng'
LIBPNG_FULL_INSTALL_PATH="$(realpath ${LIBPNG_INSTALL})"

LIBPNG_TAR="macos-${LIBPNG_INSTALL}-${LIBPNG_VERSION}.tar.gz"

# Download and extract libpng sources.
wget "${LIBPNG_URL}/${LIBPNG_DOWNLOADED_ARCHIVE}"
tar -xf "${LIBPNG_DOWNLOADED_ARCHIVE}"
rm "${LIBPNG_DOWNLOADED_ARCHIVE}"

# Set working directory to libpng build.
mkdir "${LIBPNG_BUILD}" && pushd "${LIBPNG_BUILD}"

# Build and install libpng.
../"${LIBPNG_SOURCES}"/configure --prefix="${LIBPNG_FULL_INSTALL_PATH}" --enable-shared=yes --enable-static=no
make -j"$(nproc --all)"
make install

# Go back.
popd

# Remove sources, build.
rm -rf "${LIBPNG_SOURCES}" "${LIBPNG_BUILD}"

# Compress installed.
export GZIP=-9
tar cvzf "${LIBPNG_TAR}" "${LIBPNG_INSTALL}"

# Check compressed file.
tar -tf "${LIBPNG_TAR}"
