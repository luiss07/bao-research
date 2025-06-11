#!/bin/bash

make -C $BAREMETAL_SRCS PLATFORM=qemu-riscv64-virt

mkdir -p $BUILD_GUESTS_DIR/baremetal-setup
cp $BAREMETAL_SRCS/build/qemu-riscv64-virt/baremetal.bin \
    $BUILD_GUESTS_DIR/baremetal-setup/baremetal.bin