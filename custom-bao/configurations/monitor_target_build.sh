#!/bin/bash

echo "Loading Monitor (baremetal) + Linux (target)!"

# Create monitor-target setup folder
mkdir -p ${BUILD_GUESTS_DIR}/monitor-target-setup

# --- MONITOR (baremetal) ---
make -C ${BAREMETAL_SRCS} PLATFORM=qemu-riscv64-virt

cp ${BAREMETAL_SRCS}/build/qemu-riscv64-virt/baremetal.bin \
    ${BUILD_GUESTS_DIR}/monitor-target-setup/baremetal.bin

# --- TARGET (linux) ---
LINUX_VM=linux_target
LINUX_DIR=$ROOT_DIR/linux

# Create linux binary
bash ${ROOT_DIR}/build_scripts/build_linux_binary.sh ${LINUX_VM}

# Copy linux binary into setup folder
cp ${LINUX_DIR}/linux-build/${LINUX_VM}.bin \
    ${BUILD_GUESTS_DIR}/monitor-target-setup/linux.bin

bash ${ROOT_DIR}/build_scripts/build_bao.sh monitor-target

echo "Build successful. Use './run.sh' to run."
