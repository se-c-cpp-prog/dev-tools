#!/usr/bin/env bash

set -euo pipefail

llvm_versions=(17 18 19)

LLVM_DEFAULT_VERSION=18

LLVM_APT_URL='https://apt.llvm.org'
LLVM_INSTALL_SCRIPT='llvm.sh'

# Prerequests.
sudo apt-get install -y --no-install-recommends lsb-release wget software-properties-common gnupg

# Download automatic installation script.
wget "${LLVM_APT_URL}/${LLVM_INSTALL_SCRIPT}"

# Install LLVM tools.
for version in ${llvm_versions[@]}
do
    sudo bash "${LLVM_INSTALL_SCRIPT}" "${version}" all
done

# Remove script.
rm "${LLVM_INSTALL_SCRIPT}"

# Set Clang 18 as standard clang/clang++ alternatives.
sudo ln -sf /usr/bin/clang-"${LLVM_DEFAULT_VERSION}" /usr/bin/clang
sudo ln -sf /usr/bin/clang++-"${LLVM_DEFAULT_VERSION}" /usr/bin/clang++
sudo ln -sf /usr/bin/clang-format-"${LLVM_DEFAULT_VERSION}" /usr/bin/clang-format
sudo ln -sf /usr/bin/clang-tidy-"${LLVM_DEFAULT_VERSION}" /usr/bin/clang-tidy
sudo ln -sf /usr/bin/clangd-"${LLVM_DEFAULT_VERSION}" /usr/bin/clangd
