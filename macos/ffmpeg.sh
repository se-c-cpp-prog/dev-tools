#!/usr/bin/env bash

set -euo pipefail

FFMPEG_VERSION='6.1'

FFMPEG_URL='https://git.ffmpeg.org/ffmpeg.git'

FFMPEG_SOURCES='ffmpeg-src'
FFMPEG_BUILD='ffmpeg-build'
FFMPEG_INSTALL='ffmpeg-install'

# Download FFmpeg sources.
git clone "${FFMPEG_URL}" -b "release/${FFMPEG_VERSION}" "${FFMPEG_SOURCES}"

# Set working directory to FFmpeg build.
mkdir "${FFMPEG_BUILD}" && pushd "${FFMPEG_BUILD}"

# Build and install FFmpeg.
../"${FFMPEG_SOURCES}"/configure --disable-x86asm --enable-gpl --prefix="../${FFMPEG_INSTALL}/" --enable-shared --disable-static
gmake -j"$(nproc --all)"
gmake install

# Go back.
popd

# Remove sources, build.
rm -rf "${FFMPEG_SOURCES}" "${FFMPEG_BUILD}"
