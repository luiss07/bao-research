#!/bin/bash

echo "Building Baremetal + freeRTOS!"

# Use previous compiled baremetal
mkdir -p $BUILD_GUESTS_DIR/baremetal-freeRTOS-setup
cp $BAREMETAL_SRCS/build/qemu-riscv64-virt/baremetal.bin \
    $BUILD_GUESTS_DIR/baremetal-freeRTOS-setup/baremetal.bin

export FREERTOS_SRCS=$ROOT_DIR/freertos
export FREERTOS_PARAMS="STD_ADDR_SPACE=y"

git clone --recursive --shallow-submodules\
    https://github.com/bao-project/freertos-over-bao.git\
    $FREERTOS_SRCS --branch demo

git -C $FREERTOS_SRCS checkout 421dd5600f061ae8c27d026f379da87305488ed3
# Make rtos print freeRTOS
git -C $FREERTOS_SRCS apply $PATCHES_DIR/freeRTOS.patch

# Adjust freertos submodules checkout
git -C ${ROOT_DIR}/freertos/src/baremetal-runtime checkout 74f2b187152f0b03d7bdefa7516b31dfc706b165
git -C ${ROOT_DIR}/freertos/src/freertos checkout dbf70559b27d39c1fdb68dfb9a32140b6a6777a0

make -C $FREERTOS_SRCS PLATFORM=qemu-riscv64-virt $FREERTOS_PARAMS

cp $FREERTOS_SRCS/build/qemu-riscv64-virt/freertos.bin \
    $BUILD_GUESTS_DIR/baremetal-freeRTOS-setup/freertos.bin

bash ${ROOT_DIR}/build_bao.sh baremetal-freeRTOS

echo "Build successful. Use './run.sh' to run."

