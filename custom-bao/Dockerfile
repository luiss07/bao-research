# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables to avoid user interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    bison \
    flex \
    git \
    libssl-dev \
    ninja-build \
    u-boot-tools \
    pandoc \
    libslirp-dev \
    pkg-config \
    libglib2.0-dev \
    libpixman-1-dev \
    gettext-base \
    curl \
    xterm \
    cmake \
    python3-pip \
    xilinx-bootgen \
    file \
    wget \
    cpio \
    unzip \
    rsync \
    bc \
    device-tree-compiler \
    nano \ 
    tmux \
    ssh \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip3 install pykwalify packaging pyelftools pyserial

COPY . /bao-workdir

WORKDIR /bao-workdir

RUN chmod +x *.sh

COPY ./configurations ./configurations
RUN chmod +x ./configurations/*.sh

# Download and setup built riscv64 toolchain version 13.2.0
RUN wget https://github.com/bao-project/bao-riscv-toolchain/releases/download/gc891d8dc23e/riscv64-unknown-elf-13.2.0-ubuntu-22.04.tar.gz
RUN mkdir riscv64-toolchain && tar -xvzf riscv64-unknown-elf-13.2.0-ubuntu-22.04.tar.gz -C riscv64-toolchain
RUN rm riscv64-unknown-elf-13.2.0-ubuntu-22.04.tar.gz

# Set toolchain binaries executable and set environment variable
RUN cd riscv64-toolchain \
    && chmod +x bin/*
ENV CROSS_COMPILE=/bao-workdir/riscv64-toolchain/bin/riscv64-unknown-elf-

ENV ROOT_DIR=/bao-workdir
ENV PRE_BUILT_IMGS=$ROOT_DIR/bin
ENV SETUP_BUILD=$ROOT_DIR/build
ENV PATCHES_DIR=$ROOT_DIR/patches
ENV TOOLS_DIR=$ROOT_DIR/tools
ENV BUILD_GUESTS_DIR=$SETUP_BUILD/guests
ENV BUILD_BAO_DIR=$SETUP_BUILD/bao
ENV BUILD_FIRMWARE_DIR=$SETUP_BUILD/firmware

RUN mkdir -p $BUILD_GUESTS_DIR
RUN mkdir -p $BUILD_BAO_DIR
RUN mkdir -p $BUILD_FIRMWARE_DIR
RUN mkdir -p $TOOLS_DIR/bin

ENV BAREMETAL_SRCS=$ROOT_DIR/baremetal

RUN git clone https://github.com/bao-project/bao-baremetal-guest.git\
    --branch master $BAREMETAL_SRCS

RUN git -C $BAREMETAL_SRCS apply $PATCHES_DIR/baremetal.patch

# Build baremetal configuration
RUN ./build_baremetal.sh

# Clone BAO
ENV BAO_SRCS=$ROOT_DIR/bao
RUN git clone https://github.com/bao-project/bao-hypervisor $BAO_SRCS\
    --branch main
RUN git -C $BAO_SRCS checkout a1daae75c30c204592bb3d5d9bad1930cf69dcd3

RUN ./build_bao.sh baremetal

# Install QEMU
ENV QEMU_DIR=$ROOT_DIR/tools/qemu-riscv64
RUN git clone https://github.com/qemu/qemu.git $QEMU_DIR --depth 1\
   --branch v7.2.0
RUN cd $QEMU_DIR && \
    ./configure --target-list=riscv64-softmmu --enable-slirp && \
    make -j$(nproc) && \
    make install

# Clone OpenSBI
ENV OPENSBI_DIR=$ROOT_DIR/tools/OpenSBI
RUN git clone https://github.com/bao-project/opensbi.git $OPENSBI_DIR
RUN git -C $OPENSBI_DIR checkout 4489876e933d8ba0d8bc6c64bae71e295d45faac