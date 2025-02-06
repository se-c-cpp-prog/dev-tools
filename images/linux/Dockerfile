FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

ENV SDK_DIR=/sdk

ARG DEVTOOL_EDITION=default

ENV LIBS_GOOGLETEST_VERSION='1.15.2'
ENV LIBS_ZLIB_VERSION='1.3.1'
ENV LIBS_FFTW_VERSION='3.3.10'
ENV LIBS_LIBDEFLATE_VERSION='1.21'
ENV LIBS_FFMPEG_VERSION='6.1'

# Set working directory to installations.
WORKDIR /tmp

# Update packages and install sudo.
RUN apt-get update && apt-get install -y sudo

# Install base and preinstall utils.
COPY ubuntu/base.sh .
RUN bash base.sh

# Install C/C++ compilers.
COPY images/linux/install-clang.sh .
COPY images/linux/install-gcc.sh .
RUN bash install-gcc.sh
RUN bash install-clang.sh

# Set working directory /sdk.
WORKDIR ${SDK_DIR}

# Install GoogleTest.
COPY ubuntu/googletest.sh .
RUN CC=gcc CXX=g++ bash googletest.sh ${LIBS_GOOGLETEST_VERSION} && rm googletest.sh

# Install zlib.
COPY ubuntu/zlib.sh .
RUN CC=gcc CXX=g++ bash zlib.sh ${LIBS_ZLIB_VERSION} && rm zlib.sh

# Install FFTW.
COPY ubuntu/fftw.sh .
RUN CC=gcc CXX=g++ bash fftw.sh ${LIBS_FFTW_VERSION} && rm fftw.sh

# Install libdeflate.
COPY ubuntu/libdeflate.sh .
RUN CC=gcc CXX=g++ bash libdeflate.sh ${LIBS_LIBDEFLATE_VERSION} && rm libdeflate.sh

# Install FFmpeg.
COPY ubuntu/ffmpeg.sh .
RUN CC=gcc CXX=g++ bash ffmpeg.sh ${LIBS_FFMPEG_VERSION} && rm ffmpeg.sh

# Cleanup.
RUN apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
