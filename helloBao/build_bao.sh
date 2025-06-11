#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 <config_name>"
    echo "Placement options: [baremetal, baremetal_mod, baremetal-freeRTOS, baremetal-linux, baremetal-linux-shmem]."
    exit 1
fi

config_file=$1

if [ "$config_file" != "baremetal" ] && [ "$config_file" != "baremetal_mod" ] && 
   [ "$config_file" != "baremetal-freeRTOS" ] && [ "$config_file" != "baremetal-linux" ] && 
   [ "$config_file" != "baremetal-linux-shmem" ]; then
    echo "Found not allowed config_file: ${config_file}. Use 'baremetal' | 'baremetal_mod' | 'baremetal-freeRTOS' | 'baremetal-linux' | 'baremetal-linux-shmem'."
    exit 1 
fi

echo "Building BAO with config ${config_file}." 

make -C $BAO_SRCS\
    PLATFORM=qemu-riscv64-virt\
    CONFIG_REPO=$ROOT_DIR/configs\
    CONFIG=${config_file}\
    CPPFLAGS=-DBAO_WRKDIR_IMGS=$BUILD_GUESTS_DIR

cp $BAO_SRCS/bin/qemu-riscv64-virt/${config_file}/bao.bin $BUILD_BAO_DIR/bao.bin