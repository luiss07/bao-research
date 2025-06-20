#!/bin/bash

echo "Loading Baremetal + Linux!"

# Use already built baremetal
mkdir -p $BUILD_GUESTS_DIR/baremetal-linux-setup
cp $BAREMETAL_SRCS/build/qemu-riscv64-virt/baremetal.bin \
    $BUILD_GUESTS_DIR/baremetal-linux-setup/baremetal.bin

# Copy pre built linux image
mkdir -p $BUILD_GUESTS_DIR/baremetal-linux-setup
cp $PRE_BUILT_IMGS/guests/baremetal-linux-setup/linux.bin \
    $BUILD_GUESTS_DIR/baremetal-linux-setup/linux.bin

bash ${ROOT_DIR}/build_scripts/build_bao.sh baremetal-linux

echo "Build successful. Use './run.sh' to run."
