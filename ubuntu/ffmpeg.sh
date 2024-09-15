#!/usr/bin/env bash

set -euo pipefail

FFMPEG_VERSION='6.1'

FFMPEG_URL='https://git.ffmpeg.org/ffmpeg.git'

FFMPEG_SOURCES='ffmpeg-src'
FFMPEG_BUILD='ffmpeg-build'
FFMPEG_INSTALL='ffmpeg'

FFMPEG_TAR="ubuntu-${FFMPEG_INSTALL}-${FFMPEG_VERSION}.tar.gz"

# Download FFmpeg sources.
git clone "${FFMPEG_URL}" -b "release/${FFMPEG_VERSION}" "${FFMPEG_SOURCES}"

# Set working directory to FFmpeg build.
mkdir "${FFMPEG_BUILD}" && pushd "${FFMPEG_BUILD}"

# Build and install FFmpeg.
../"${FFMPEG_SOURCES}"/configure --cc="${CC}" --cxx="${CXX}" --disable-x86asm --enable-gpl --prefix="../${FFMPEG_INSTALL}/" --enable-shared --disable-static
make -j"$(nproc --all)"
make install

# Go back.
popd

# Remove sources, build.
rm -rf "${FFMPEG_SOURCES}" "${FFMPEG_BUILD}"

# Compress installed.
export GZIP=-9
tar cvzf "${FFMPEG_TAR}" "${FFMPEG_INSTALL}"

# Check compressed file.
tar -tf "${FFMPEG_TAR}"
