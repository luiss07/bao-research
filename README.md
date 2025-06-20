# Utils

## Links 

- **Bao WiP documentation**: [https://github.com/bao-project/bao-docs/blob/feat/bao-classic_config_guests/source/bao_hyp/config.rst](https://github.com/bao-project/bao-docs/blob/feat/bao-classic_config_guests/source/bao_hyp/config.rst)
- **qemu-virt memory mapping**: [https://github.com/qemu/qemu/blob/master/hw/riscv/virt.c](https://github.com/qemu/qemu/blob/master/hw/riscv/virt.c)
- **qemu-virt available IRQ**: [https://github.com/qemu/qemu/blob/master/include/hw/riscv/virt.h](https://github.com/qemu/qemu/blob/master/include/hw/riscv/virt.h)
- **linux device tree and memory allocation**: [https://github.com/bao-project/bao-helloworld/blob/risc-v/srcs/devicetrees/qemu-riscv64-virt/linux.dts](https://github.com/bao-project/bao-helloworld/blob/risc-v/srcs/devicetrees/qemu-riscv64-virt/linux.dts)
- **baremetal memory allocation**: [https://github.com/bao-project/bao-baremetal-guest/blob/master/src/platform/qemu-riscv64-virt/inc/plat.h](https://github.com/bao-project/bao-baremetal-guest/blob/master/src/platform/qemu-riscv64-virt/inc/plat.h)
- **qemu-riscv64 platform (cpus definition)**: [https://github.com/bao-project/bao-hypervisor/blob/main/src/platform/qemu-riscv64-virt/virt_desc.c#L20](https://github.com/bao-project/bao-hypervisor/blob/main/src/platform/qemu-riscv64-virt/virt_desc.c#L20)

## For linux image

The `qemu-riscv64-virt` command is using as subnet `192.168.42.0/24`. Since by default the linux OS does not have the Gateway set, it is necessary to set it manually. QEMU assigns the gateway address to the second host IP in the subnet (e.g. `*.2`). 

```bash
ip route add default via 192.168.42.2
```
and to configure the DNS server use:
```bash
echo "nameserver 192.168.42.3" > /etc/resolv.conf
```

# Repo structure

- **bitstreams**: built bitstreams for FPGA genesys 2 board [source](https://github.com/malejo97/cva6-spmp-walkthrough)
> [!NOTE]  
> To use FPGA it is neccessary to install Vivado. After installation Vivado needs the board files for Genesys 2, which can be download from this [guide](https://digilent.com/reference/software/vivado/board-files?redirect=1)
- **custom-bao**: setup to run Bao with custom configurations 
- **helloBao**: hello world Bao application [source](https://github.com/bao-project/bao-helloworld/tree/risc-v)

# TODOs

- [X] Installation and configuration of Bao
  - [X] Study of Bao's memory partition: Bao does not allow to overlap memory reagions in any way. 
  - [X] Permissions: devices IRQs can be assigned only to one Guest, because the IRQ is sent to the Guest by using the IRQ_ID field which is unique. 
- [X] Hardware setup with CVA6
- [ ] Design and implementation of a monitor and target VMs
  - [ ] [WiP] Qemu
  - [ ] FPGA Genesys 2