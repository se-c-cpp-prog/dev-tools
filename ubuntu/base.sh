#!/usr/bin/env bash

set -euo pipefail

# Update all packages links.
sudo apt-get update

# Install all basic utils.
sudo apt-get install -y --no-install-recommends make cmake tar autoconf automake libtool nasm python3 python3-pip python3-setuptools python3-wheel ninja-build
