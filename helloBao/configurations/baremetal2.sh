#!/bin/bash

echo "Building baremetal with 4CPUs and 128MiB Memory"

bash ${ROOT_DIR}/build_baremetal.sh
bash ${ROOT_DIR}/build_bao.sh baremetal_mod

echo "Build successful. Use './run.sh' to run."