#include <config.h>

VM_IMAGE(monitor_image, XSTR(BAO_WRKDIR_IMGS/monitor-target-setup/baremetal.bin))
VM_IMAGE(target_image, XSTR(BAO_WRKDIR_IMGS/monitor-target-setup/linux.bin))

struct config config = {

    CONFIG_HEADER

    .vmlist_size = 2,
    .vmlist = (struct vm_config[]) {
        {
            .image = VM_IMAGE_BUILTIN(monitor_image, 0x80200000),

            .entry = 0x80200000,

            .platform = {
                .cpu_num = 1,

                .region_num = 1,
                .regions =  (struct vm_mem_region[]) {
                    {
                        .base = 0x80200000,
                        .size = 0x4000000 
                    }
                },

                .dev_num = 1,
                .devs =  (struct vm_dev_region[]) {
                    {
                        /* 8250 */
                        .pa = 0x10000000,
                        .va = 0x10000000,
                        .size = 0x1000,
                        .interrupt_num = 1,
                        .interrupts = (irqid_t[]) {10}
                    },
                    {
                        /* virtio devices */
                        .pa = 0x10001000,
                        .va = 0x10001000,
                        .size = 0x8000,
                    }
                },

                .arch = {
                   .irqc = {
                        .plic = {
                            .base = 0xc000000,
                        },
                   },
                },
            },
        },
        { 
            .image = VM_IMAGE_BUILTIN(target_image, 0x90200000),

            .entry = 0x90200000,

            .platform = {
                .cpu_num = 3,

                .region_num = 1,
                .regions =  (struct vm_mem_region[]) {
                    {
                        .base = 0x90000000,
                        .size = 0x40000000,
                        .place_phys = true,
                        .phys = 0x90000000
                    }
                },

                .dev_num = 1,
                .devs =  (struct vm_dev_region[]) {
                    {
                        /* virtio devices */
                        .pa = 0x10001000,
                        .va = 0x10001000,
                        .size = 0x8000,
                        .interrupt_num = 2,
                        .interrupts = (irqid_t[]) {7,8}
                    },
                },

                .arch = {
                   .irqc = {
                        .plic = {
                            .base = 0xc000000,
                        },
                   },
                },
            },
        }
    },
};