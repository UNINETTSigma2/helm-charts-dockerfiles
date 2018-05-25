#!/bin/bash

# Strict mode
set -euo pipefail

echo "Starting RSudio Server"
/usr/lib/rstudio-server/bin/rserver --server-daemonize 0 --auth-none 0 &
shiny-server > /var/log/shiny-server.log &

sleep inf
