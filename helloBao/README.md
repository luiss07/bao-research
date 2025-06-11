# Bao walkthrough

## Run

```bash
docker build -t bao .
# Run the container as it is
docker run -it --rm bao
# Run the container with a mounted configurations directory
docker run -it --rm -v ./configurations/:/configurations/ bao
```

## Configuration

### Baremetal-linux
To connect to the linux instance, you need to execute the following command:

```bash
pyserial-miniterm --filter=direct /dev/pts/<number>
```

where `<number>` is the number of the PTY that you can find just after running the `qemu-system-riscv64` command found in `run.sh`.

