#!/usr/bin/env bash

set -euo pipefail

FFTW_VERSION="${1}"

FFTW_URL='https://www.fftw.org'

FFTW_SOURCES="fftw-${FFTW_VERSION}"
FFTW_DOWNLOADED_ARCHIVE="${FFTW_SOURCES}.tar.gz"
FFTW_BUILD='fftw-build'
FFTW_INSTALL='fftw-install'

# Download and extract FFTW sources.
wget "${FFTW_URL}/${FFTW_DOWNLOADED_ARCHIVE}"
tar -xf "${FFTW_DOWNLOADED_ARCHIVE}"
rm "${FFTW_DOWNLOADED_ARCHIVE}"

# Set working directory to ZLIB build.
mkdir "${FFTW_BUILD}" && pushd "${FFTW_BUILD}"

# Build and install FFTW (Single precision).
cmake ../"${FFTW_SOURCES}"/ -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=../"${FFTW_INSTALL}"/ -D ENABLE_FLOAT=ON -D BUILD_SHARED_LIBS=ON
gmake -j"$(nproc --all)"
gmake install

# Go back.
popd

# Remove build.
rm -rf "${FFTW_BUILD}"

# Set working directory to ZLIB build.
mkdir "${FFTW_BUILD}" && pushd "${FFTW_BUILD}"

# Build and install FFTW (Double precision).
cmake ../"${FFTW_SOURCES}"/ -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=../"${FFTW_INSTALL}"/ -D ENABLE_DOUBLE=ON -D BUILD_SHARED_LIBS=ON
gmake -j"$(nproc --all)"
gmake install

# Go back.
popd

# Remove sources, build.
rm -rf "${FFTW_SOURCES}" "${FFTW_BUILD}"
