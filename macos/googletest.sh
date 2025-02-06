#!/usr/bin/env bash

set -euo pipefail

GOOGLETEST_VERSION="${1}"

GOOGLETEST_URL='https://github.com/google/googletest.git'

GOOGLETEST_SOURCES='googletest-src'
GOOGLETEST_BUILD='googletest-build'
GOOGLETEST_INSTALL='googletest-install'

# Download GoogleTest sources.
git clone "${GOOGLETEST_URL}" -b "v${GOOGLETEST_VERSION}" "${GOOGLETEST_SOURCES}"

# Set working directory to GoogleTest build.
mkdir "${GOOGLETEST_BUILD}" && pushd "${GOOGLETEST_BUILD}"

# Build and install GoogleTest.
cmake ../"${GOOGLETEST_SOURCES}"/ -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=../"${GOOGLETEST_INSTALL}"/ -D BUILD_SHARED_LIBS=ON
gmake -j"$(nproc --all)"
gmake install

# Go back.
popd

# Remove sources, build.
rm -rf "${GOOGLETEST_SOURCES}" "${GOOGLETEST_BUILD}"
