FROM ubuntu:22.04

ARG COMPILER_NAME
ARG COMPILER_VERSION

ENV SDK=/sdk

# Install SUDO.
RUN apt-get update -qq && apt-get install -y sudo

# Install base utils.
COPY ubuntu/base.sh .
RUN bash base.sh && rm base.sh

# Install C/C++ build tools via setup-cpp.
RUN apt-get install -y --no-install-recommends nodejs npm && \
    # install setup-cpp
    npm install -g setup-cpp@v0.44.0 && \
    # install the compiler and tools
    setup-cpp \
        --nala true \
        --compiler ${COMPILER_NAME}-${COMPILER_VERSION} && \
    # cleanup
    nala autoremove -y && \
    nala autopurge -y && \
    apt-get clean && \
    nala clean --lists && \
    apt-get remove -y --purge --autoremove nodejs npm

WORKDIR ${SDK}

# Install Criterion.
COPY ubuntu/criterion.sh .
RUN bash criterion.sh && rm criterion.sh

# Install GoogleTest.
COPY ubuntu/googletest.sh .
RUN bash googletest.sh && rm googletest.sh

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
RUN bash ffmpeg.sh && rm ffmpeg.sh
