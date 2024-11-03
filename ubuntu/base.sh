#!/usr/bin/env bash

set -euo pipefail

# Update all packages links.
sudo apt-get update

# Install "builder" tools.
sudo apt-get install -y --no-install-recommends make cmake tar autoconf automake libtool nasm ninja-build wget

# Install Python tools.
sudo apt-get install -y --no-install-recommends python3 python3-pip python3-setuptools python3-wheel python3-venv python3-dev

# Install GitHub tools.
sudo apt-get install -y --no-install-recommends git
