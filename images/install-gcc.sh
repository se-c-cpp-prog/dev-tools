#!/usr/bin/env bash

set -euo pipefail

gcc_versions=(10 11 12)

GCC_DEFAULT_VERSION=11

# Install GCC tools.
for version in ${gcc_versions[@]}
do
    sudo apt-get install -y --no-install-recommends \
        gcc-"${version}" g++-"${version}" gcc-"${version}"-multilib g++-"${version}"-multilib
done

# Install additional GNU tools.
sudo apt-get install -y --no-install-recommends gdb binutils build-essential valgrind

# Set GCC 11 as standard gcc/g++ alternatives.
sudo ln -sf /usr/bin/gcc-"${GCC_DEFAULT_VERSION}" /usr/bin/gcc
sudo ln -sf /usr/bin/g++-"${GCC_DEFAULT_VERSION}" /usr/bin/g++

# Set GCC 11 as standard CC/CXX alternatives.
sudo ln -sf /usr/bin/gcc-"${GCC_DEFAULT_VERSION}" /usr/bin/cc
sudo ln -sf /usr/bin/g++-"${GCC_DEFAULT_VERSION}" /usr/bin/c++
