#!/usr/bin/env bash

set -euo pipefail

# Install all basic utils.
brew install --cask brewtarget
brew install make cmake tar autoconf automake libtool python-setuptools ninja
