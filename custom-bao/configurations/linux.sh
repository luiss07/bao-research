#!/bin/bash

echo "Building Linux only!"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <linux_dts>"
    echo ".dts file must be inside '${ROOT_DIR}/srcs/devicetrees/qemu-riscv64-virt/'"
    exit 1
fi

cp $BAREMETAL_SRCS/build/qemu-riscv64-virt/baremetal.bin \
    $BUILD_GUESTS_DIR/linux-setup/baremetal.bin

LINUX_VM=$(basename $1 .dts)
LINUX_DIR=$ROOT_DIR/linux

# Create setup dir
mkdir -p ${BUILD_GUESTS_DIR}/linux-setup

bash ${ROOT_DIR}/build_scripts/build_linux_binary.sh ${LINUX_VM}

cp ${LINUX_DIR}/linux-build/${LINUX_VM}.bin \
    ${BUILD_GUESTS_DIR}/linux-setup/linux.bin

bash ${ROOT_DIR}/build_scripts/build_bao.sh linux

echo "Build successful. Use './run.sh' to run."
