FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

ENV SDK_DIR=/sdk

ARG DEVTOOL_EDITION=default

# Set working directory to installations.
WORKDIR /tmp

# Update packages and install sudo.
RUN apt-get update && apt-get install -y sudo

# Install base and preinstall utils.
COPY ubuntu/base.sh .
RUN bash base.sh

# Install C/C++ compilers.
COPY images/ubuntu/install-clang.sh .
COPY images/ubuntu/install-gcc.sh .
RUN bash install-gcc.sh
RUN bash install-clang.sh

# Set working directory /sdk.
WORKDIR ${SDK_DIR}

# Install Criterion.
COPY ubuntu/criterion.sh .
RUN CC=gcc CXX=g++ bash criterion.sh && rm criterion.sh

# Install GoogleTest.
COPY ubuntu/googletest.sh .
RUN CC=gcc CXX=g++ bash googletest.sh && rm googletest.sh

# Install zlib.
COPY ubuntu/zlib.sh .
RUN CC=gcc CXX=g++ bash zlib.sh && rm zlib.sh

# Install FFTW.
COPY ubuntu/fftw.sh .
RUN CC=gcc CXX=g++ bash fftw.sh && rm fftw.sh

# Install libpng.
COPY ubuntu/libpng.sh .
RUN CC=gcc CXX=g++ bash libpng.sh && rm libpng.sh

# Install libdeflate.
COPY ubuntu/libdeflate.sh .
RUN CC=gcc CXX=g++ bash libdeflate.sh && rm libdeflate.sh

# Install ISA-L.
COPY ubuntu/isal.sh .
RUN CC=gcc CXX=g++ bash isal.sh && rm isal.sh

# Install FFmpeg.
COPY ubuntu/ffmpeg.sh .
RUN CC=gcc CXX=g++ bash ffmpeg.sh && rm ffmpeg.sh

# Cleanup.
RUN apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
