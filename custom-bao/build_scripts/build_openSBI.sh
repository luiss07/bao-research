#!/bin/bash

# Build bao into OpenSBI
make -C $TOOLS_DIR/OpenSBI PLATFORM=generic \
    FW_PAYLOAD=y \
    FW_PAYLOAD_FDT_ADDR=0x80100000\
    FW_PAYLOAD_PATH=$BUILD_BAO_DIR/bao.bin

# Copy built elf to generic directory
cp $TOOLS_DIR/OpenSBI/build/platform/generic/firmware/fw_payload.elf \
    $TOOLS_DIR/bin/opensbi.elf