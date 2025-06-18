#!/bin/bash

if [ ! -n "$ROOT_DIR" ]; then
    echo "Variable 'ROOT_DIR' not initializated. Maybe you are not inside docker." 
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "Usage: $0 <linux_dts>"
    echo "Looking for dts into '$ROOT_DIR/srcs/devicetrees/qemu-riscv64-virt/'"
    exit 1
fi

echo " === WARNING ==="
echo "This script has to be run either inside Docker or after 'build_linux_image.sh'"

echo "Building Linux image!"

export LINUX_VM=$(basename $1 .dts)

export LINUX_DIR=$ROOT_DIR/linux
export LINUX_VERSION=v6.1
export LINUX_SRCS=$LINUX_DIR/linux-$LINUX_VERSION

export BUILDROOT_SRCS=$LINUX_DIR/buildroot-riscv64-$LINUX_VERSION
export BUILDROOT_DEFCFG=$ROOT_DIR/srcs/buildroot/riscv64.config
export LINUX_OVERRIDE_SRCDIR=$LINUX_SRCS

if [ ! -f $ROOT_DIR/srcs/devicetrees/qemu-riscv64-virt/$LINUX_VM.dts ]; then
    echo "File '$LINUX_VM.dts' not found at '$ROOT_DIR/srcs/devicetrees/qemu-riscv64-virt/'!"
    exit 1
fi

mkdir -p $LINUX_DIR/linux-$LINUX_VERSION
mkdir -p $LINUX_DIR/linux-build

if [ ! -d $LINUX_SRCS ]; then
    echo "Linux folder not found. Run 'build_linux_image.sh'"
    exit 1
fi

if [ ! -d $BUILDROOT_SRCS ]; then
    echo "Buildroot folder not found. Run 'build_linux_image.sh'"
fi

cd $BUILDROOT_SRCS

if [ ! -f "$BUILDROOT_SRCS/output/images/Image-qemu-riscv64-virt" ]; then
    echo "> '$BUILDROOT_SRCS/output/images/Image-qemu-riscv64-virt' not found. Building..." 
    make defconfig BR2_DEFCONFIG=$BUILDROOT_DEFCFG
    make linux-reconfigure all 

    mv $BUILDROOT_SRCS/output/images/Image\
        $BUILDROOT_SRCS/output/images/Image-qemu-riscv64-virt
else
    echo "=== FOUND LINUX QEMU-RISCV64 IMAGE ==="
    echo "Image is located at $BUILDROOT_SRCS/output/images/"
fi

dtc $ROOT_DIR/srcs/devicetrees/qemu-riscv64-virt/$LINUX_VM.dts >\
    $LINUX_DIR/linux-build/$LINUX_VM.dtb

make -j $(nproc) -C $ROOT_DIR/srcs/lloader\
    ARCH=riscv64\
    IMAGE=$BUILDROOT_SRCS/output/images/Image-qemu-riscv64-virt\
    DTB=$LINUX_DIR/linux-build/$LINUX_VM.dtb\
    TARGET=$LINUX_DIR/linux-build/$LINUX_VM

if [ -f "${LINUX_DIR}/linux-build/${LINUX_VM}.bin" ]; then
    echo "Build successful. Binary saved at '${LINUX_DIR}/linux-build/'."
else 
    echo "Something went wrong: no binary found at '${LINUX_DIR}/linux-build/'."
fi