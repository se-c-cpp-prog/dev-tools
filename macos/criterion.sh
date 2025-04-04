#!/usr/bin/env bash

set -euo pipefail

CRITERION_VERSION="${1}"

CRITERION_URL='https://github.com/Snaipe/Criterion.git'

CRITERION_SOURCES='criterion-src'
CRITERION_BUILD='criterion-build'
CRITERION_INSTALL='criterion-install'

# Create all necessary directories.
mkdir "${CRITERION_BUILD}" "${CRITERION_INSTALL}"

CRITERION_FULL_PATH_BUILD="$(realpath "${CRITERION_BUILD}")"
CRITERION_FULL_PATH_INSTALL="$(realpath ${CRITERION_INSTALL})"

# Download Criterion sources.
git clone "${CRITERION_URL}" -b "v${CRITERION_VERSION}" "${CRITERION_SOURCES}"

# Set working directory to Criterion sources.
pushd "${CRITERION_SOURCES}"

# Setup meson.
python3 -m venv venv
./venv/bin/pip3 install meson

# Go back.
popd

# Configure meson.
./"${CRITERION_SOURCES}"/venv/bin/meson ./"${CRITERION_SOURCES}" "${CRITERION_FULL_PATH_BUILD}" --prefix "${CRITERION_FULL_PATH_INSTALL}" --buildtype release --default-library shared -Dc_std=gnu11

# Set working directory to Criterion builds.
pushd "${CRITERION_BUILD}"

# Build and install Criterion.
ninja
ninja install

# Go back.
popd

# Remove sources, build.
rm -rf "${CRITERION_SOURCES}" "${CRITERION_BUILD}"
