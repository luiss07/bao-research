#include <config.h>

// VM_IMAGE(baremetal_image, XSTR(BAO_WRKDIR_IMGS/linux-setup/baremetal.bin))
VM_IMAGE(linux_image, XSTR(BAO_WRKDIR_IMGS/linux-setup/linux.bin))

struct config config = {

    CONFIG_HEADER

    .vmlist_size = 1,
    .vmlist = (struct vm_config[]) {
        { 
            .image = VM_IMAGE_BUILTIN(linux_image, 0x90200000),

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
                        .interrupt_num = 8,
                        .interrupts = (irqid_t[]) {1,2,3,4,5,6,7,8}
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