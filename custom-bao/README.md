# Custom BAO configurations

## Useful commands
```bash
docker build -t bao .

docker run -it --rm -v ./configurations/:/bao-workdir/configurations/ -v ./configs/:/bao-workdir/configs/ bao
```

Connect to the running linux instance:
```bash
pyserial-miniterm --filter=direct /dev/pts/<number>
```
or 
```bash
ssh root@127.0.0.1 -p 5555
```

## Monitor-target configurations

### Informations

- **Linux (target)**: IRQ devices, **serial** and **network interface** (net0) gets mapped to IRQ 7 and 8 respectively (see [linux_target.dts](./srcs/devicetrees/qemu-riscv64-virt/linux_target.dts)).

- **MMIO Device Register Layout**: found at section 4.2.2 of [OASIS documentation](https://docs.oasis-open.org/virtio/virtio/v1.0/cs04/virtio-v1.0-cs04.html#x1-1110002)

