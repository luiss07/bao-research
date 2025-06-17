#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 <config_name>"
    echo "Configs found in '$ROOR_DIR/configs/'."
    exit 1
fi

config_file=$(basename $1 .c)

if [ ! -f $ROOT_DIR/configs/$config_file.c ]; then
    echo "File '$config_file.c' not found at '$ROOT_DIR/configs/'!"
    exit 1
fi

echo "Building BAO with config ${config_file}." 

make -C $BAO_SRCS\
    PLATFORM=qemu-riscv64-virt\
    CONFIG_REPO=$ROOT_DIR/configs\
    CONFIG=${config_file}\
    CPPFLAGS=-DBAO_WRKDIR_IMGS=$BUILD_GUESTS_DIR

cp $BAO_SRCS/bin/qemu-riscv64-virt/${config_file}/bao.bin $BUILD_BAO_DIR/bao.bin