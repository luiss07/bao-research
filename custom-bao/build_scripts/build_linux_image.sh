#!/bin/bash

# Build Linux from scratch (its possible to use also a pre-built image)
export LINUX_DIR=$ROOT_DIR/linux
export LINUX_REPO=https://github.com/torvalds/linux.git
export LINUX_VERSION=v6.1

export LINUX_SRCS=$LINUX_DIR/linux-$LINUX_VERSION

mkdir -p $LINUX_DIR/linux-$LINUX_VERSION
mkdir -p $LINUX_DIR/linux-build

git clone $LINUX_REPO $LINUX_SRCS\
    --depth 1 --branch $LINUX_VERSION
git -C $LINUX_SRCS apply $ROOT_DIR/srcs/patches/$LINUX_VERSION/*.patch

export LINUX_CFG_FRAG=$(ls $ROOT_DIR/srcs/configs/base.config\
    $ROOT_DIR/srcs/configs/riscv64.config\
    $ROOT_DIR/srcs/configs/qemu-riscv64-virt.config 2> /dev/null)

export BUILDROOT_SRCS=$LINUX_DIR/buildroot-riscv64-$LINUX_VERSION
export BUILDROOT_DEFCFG=$ROOT_DIR/srcs/buildroot/riscv64.config
export LINUX_OVERRIDE_SRCDIR=$LINUX_SRCS

git clone https://github.com/buildroot/buildroot.git $BUILDROOT_SRCS\
    --depth 1 --branch 2022.11
cd $BUILDROOT_SRCS

make defconfig BR2_DEFCONFIG=$BUILDROOT_DEFCFG
make linux-reconfigure all

mv $BUILDROOT_SRCS/output/images/Image\
    $BUILDROOT_SRCS/output/images/Image-qemu-riscv64-virt
