#!/usr/bin/env bash

set -euo pipefail

GCC_VERSION=${1}

# Install GCC tools.
sudo apt-get install -y --no-install-recommends \
    gcc-"${GCC_VERSION}" g++-"${GCC_VERSION}" gcc-"${GCC_VERSION}"-multilib g++-"${GCC_VERSION}"-multilib \
    gdb binutils build-essential

# Set GCC as standard gcc/g++ alternatives.
sudo ln -sf /usr/bin/gcc-"${GCC_VERSION}" /usr/bin/gcc
sudo ln -sf /usr/bin/g++-"${GCC_VERSION}" /usr/bin/g++

# Set GCC as standard CC/CXX alternatives.
sudo ln -sf /usr/bin/gcc-"${GCC_VERSION}" /usr/bin/cc
sudo ln -sf /usr/bin/g++-"${GCC_VERSION}" /usr/bin/c++
