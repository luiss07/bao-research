#!/bin/bash

make -C $TOOLS_DIR/OpenSBI PLATFORM=generic \
    FW_PAYLOAD=y \
    FW_PAYLOAD_FDT_ADDR=0x80100000\
    FW_PAYLOAD_PATH=$BUILD_BAO_DIR/bao.bin

cp $TOOLS_DIR/OpenSBI/build/platform/generic/firmware/fw_payload.elf \
    $TOOLS_DIR/bin/opensbi.elf

qemu-system-riscv64 -nographic\
    -M virt -cpu rv64 -m 4G -smp 4\
    -bios $TOOLS_DIR/bin/opensbi.elf\
    -device virtio-net-device,netdev=net0 \
    -netdev user,id=net0,net=192.168.42.0/24,hostfwd=tcp:127.0.0.1:5555-:22\
    -device virtio-serial-device -chardev pty,id=serial3 -device virtconsole,chardev=serial3