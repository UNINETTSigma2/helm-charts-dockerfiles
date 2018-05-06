#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# Exec the specified command or fall back on bash
if [ $# -eq 0 ]; then
    cmd=bash
else
    cmd=$*
fi

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/nvidia/lib64/:/usr/local/cuda-8.0/lib64/
export PATH=$PATH:/usr/local/nvidia/bin/:/usr/local/cuda-8.0/bin/
# Execute the command
echo "Executing the command: $cmd"
exec $cmd
