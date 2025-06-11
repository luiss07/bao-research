#!/bin/bash

echo "Building Baremetal + Linux!"

# Use already built baremetal
mkdir -p $BUILD_GUESTS_DIR/baremetal-linux-setup
cp $BAREMETAL_SRCS/build/qemu-riscv64-virt/baremetal.bin \
    $BUILD_GUESTS_DIR/baremetal-linux-setup/baremetal.bin

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

export LINUX_VM=linux
dtc $ROOT_DIR/srcs/devicetrees/qemu-riscv64-virt/$LINUX_VM.dts >\
    $LINUX_DIR/linux-build/$LINUX_VM.dtb

make -j $(nproc) -C $ROOT_DIR/srcs/lloader\
    ARCH=riscv64\
    IMAGE=$BUILDROOT_SRCS/output/images/Image-qemu-riscv64-virt\
    DTB=$LINUX_DIR/linux-build/$LINUX_VM.dtb\
    TARGET=$LINUX_DIR/linux-build/$LINUX_VM

cp $LINUX_DIR/linux-build/$LINUX_VM.bin \
    $BUILD_GUESTS_DIR/baremetal-linux-setup/linux.bin

bash ${ROOT_DIR}/build_bao.sh baremetal-linux

echo "Build successful. Use './run.sh' to run."
