# Bao walkthrough

## Run

```bash
docker build -t bao .
# Run the container as it is
docker run -it --rm bao
# Run the container with a mounted configurations directory
docker run -it --rm -v ./configurations/:/bao-helloworld/configurations/ bao
```

## Configuration

### Baremetal-linux
To connect to the linux instance, you need to execute the following command:

```bash
pyserial-miniterm --filter=direct /dev/pts<number>
```

where `<number>` is the number of the PTY that you can find just after running the `qemu-system-riscv64` command found in `run.sh`.


## Utils

- qemu-virt memory mapping: [https://github.com/qemu/qemu/blob/master/hw/riscv/virt.c](https://github.com/qemu/qemu/blob/master/hw/riscv/virt.c)
- linux device tree and memory allocation: [https://github.com/bao-project/bao-helloworld/blob/risc-v/srcs/devicetrees/qemu-riscv64-virt/linux.dts](https://github.com/bao-project/bao-helloworld/blob/risc-v/srcs/devicetrees/qemu-riscv64-virt/linux.dts)
- baremetal memory allocation: [https://github.com/bao-project/bao-baremetal-guest/blob/master/src/platform/qemu-riscv64-virt/inc/plat.h](https://github.com/bao-project/bao-baremetal-guest/blob/master/src/platform/qemu-riscv64-virt/inc/plat.h)