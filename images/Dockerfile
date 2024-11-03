FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

ARG IMAGE_COMPILER_NAME
ARG IMAGE_COMPILER_VERS

ENV SDK_DIR=/sdk

# Update packages and install sudo.
RUN apt-get update && apt-get install -y sudo

# Install base and preinstall utils.
COPY ubuntu/base.sh .
COPY images/install-preinstall.sh .
RUN bash base.sh && rm base.sh
RUN bash install-preinstall.sh && rm install-preinstall.sh

# Set working directory /sdk.
WORKDIR ${SDK_DIR}

# Install Criterion.
COPY ubuntu/criterion.sh .
RUN bash criterion.sh && rm criterion.sh

# Install GoogleTest.
COPY ubuntu/googletest.sh .
RUN CC=gcc CXX=g++ bash googletest.sh && rm googletest.sh

# Install zlib.
COPY ubuntu/zlib.sh .
RUN bash zlib.sh && rm zlib.sh

# Install FFTW.
COPY ubuntu/fftw.sh .
RUN bash fftw.sh && rm fftw.sh

# Install libpng.
COPY ubuntu/libpng.sh .
RUN bash libpng.sh && rm libpng.sh

# Install libdeflate.
COPY ubuntu/libdeflate.sh .
RUN bash libdeflate.sh && rm libdeflate.sh

# Install ISA-L.
COPY ubuntu/isal.sh .
RUN bash isal.sh && rm isal.sh

# Install FFmpeg.
COPY ubuntu/ffmpeg.sh .
RUN CC=gcc CXX=g++ bash ffmpeg.sh && rm ffmpeg.sh

# Install C/C++ build tools.
COPY images/install-postinstall.sh .
COPY images/install-${IMAGE_COMPILER_NAME}.sh .
RUN bash install-postinstall.sh && rm install-postinstall.sh
RUN bash install-${IMAGE_COMPILER_NAME}.sh ${IMAGE_COMPILER_VERS} && rm install-${IMAGE_COMPILER_NAME}.sh
