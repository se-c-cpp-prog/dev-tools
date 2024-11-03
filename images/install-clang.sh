#!/usr/bin/env bash

set -euo pipefail

LLVM_VERSION=$1

LLVM_APT_URL='https://apt.llvm.org'
LLVM_INSTALL_SCRIPT='llvm.sh'

# Prerequests.
sudo apt-get install -y --no-install-recommends lsb-release wget software-properties-common gnupg

# Download automatic installation script.
wget "${LLVM_APT_URL}/${LLVM_INSTALL_SCRIPT}"

# Install LLVM tools.
sudo bash "${LLVM_INSTALL_SCRIPT}" 18 all

# Remove script.
rm "${LLVM_INSTALL_SCRIPT}"

# Set Clang as standard clang/clang++ alternatives.
sudo ln -sf /usr/bin/clang-"${LLVM_VERSION}" /usr/bin/clang
sudo ln -sf /usr/bin/clang++-"${LLVM_VERSION}" /usr/bin/clang++
