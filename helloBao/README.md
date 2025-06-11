# Bao walkthrough

## Run

```bash
docker build -t bao .
# Run the container as it is
docker run -it --rm bao
# Run the container with a mounted configurations directory
docker run -it --rm -v ./configurations/:/configurations/ bao
```