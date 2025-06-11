#!/bin/bash

echo "Configuring Baremetal + Linux with Shared memory!"

# Add shared memory to baremetal code
git -C $BAREMETAL_SRCS apply $PATCHES_DIR/baremetal_shmem.patch

# Build the the updated baremetal
make -C $BAREMETAL_SRCS PLATFORM=qemu-riscv64-virt

mkdir -p $BUILD_GUESTS_DIR/baremetal-linux-shmem-setup
cp $BAREMETAL_SRCS/build/qemu-riscv64-virt/baremetal.bin \
    $BUILD_GUESTS_DIR/baremetal-linux-shmem-setup/baremetal.bin

export LINUX_VM=linux-shmem
dtc $ROOT_DIR/srcs/devicetrees/qemu-riscv64-virt/$LINUX_VM.dts >\
    $BUILD_GUESTS_DIR/baremetal-linux-shmem-setup/$LINUX_VM.dtb

make -j $(nproc) -C $ROOT_DIR/srcs/lloader\
    ARCH=riscv64\
    IMAGE=$PRE_BUILT_IMGS/guests/baremetal-linux-shmem-setup/Image-qemu-riscv64-virt\
    DTB=$BUILD_GUESTS_DIR/baremetal-linux-shmem-setup/$LINUX_VM.dtb\
    TARGET=$BUILD_GUESTS_DIR/baremetal-linux-shmem-setup/$LINUX_VM

bash ${ROOT_DIR}/build_bao.sh baremetal-linux-shmem

echo "Build successful. Use './run.sh' to run."
