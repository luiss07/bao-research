/**
 * Simple VirtIO Net device check
 */
#include <core.h>
#include <stdio.h>
#include <cpu.h>
#include <wfi.h>

#define VIRTIO_BASE 0x10001000
#define VIRTIO_NET_BASE (VIRTIO_BASE + 0x7000)
#define VIRTIO_MAGIC_OFFSET 0x00
#define VIRTIO_DEVICE_ID_OFFSET 0x08
#define VIRTIO_MAGIC_VALUE 0x74726976
#define VIRTIO_NET_DEVICE_ID 1

void check_virtio_net(void) {
    printf("Checking VirtIO device at 0x%x\n", VIRTIO_NET_BASE);
    
    // Read magic number
    uint32_t *magic_reg = (uint32_t *)(VIRTIO_NET_BASE + VIRTIO_MAGIC_OFFSET);
    uint32_t magic = *magic_reg;
    
    printf("Magic: 0x%x ", magic);
    if (magic == VIRTIO_MAGIC_VALUE) {
        printf("(Valid VirtIO)\n");
        
        // Read device ID
        uint32_t *device_id_reg = (uint32_t *)(VIRTIO_NET_BASE + VIRTIO_DEVICE_ID_OFFSET);
        uint32_t device_id = *device_id_reg;
        
        printf("Device ID: %d ", device_id);
        if (device_id == VIRTIO_NET_DEVICE_ID) {
            printf("(VirtIO Net device found!)\n");
        } else {
            printf("(Not a network device)\n");
        }
    } else {
        printf("(Not a VirtIO device)\n");
    }
}

void main(void){
    if(cpu_is_master()){
        printf("=== VirtIO Net Check ===\n");
        check_virtio_net();
    }
    
    while(1) {
        wfi();
    }
}