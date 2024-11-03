#!/usr/bin/env bash

# Remove all "builder" tools: from base and preinstall.
sudo apt-get remove -y --purge --autoremove \
    make cmake autoconf automake libtool nasm ninja-build wget \
    gcc g++
