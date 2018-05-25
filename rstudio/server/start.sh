#!/bin/bash

# Strict mode
set -euo pipefail

echo "Starting RSudio Server"
/usr/lib/rstudio-server/bin/rserver --server-daemonize 0 --auth-none 0 &
echo "Starting Shiny Server"
shiny-server > /var/log/shiny-server/server.log &

sleep inf
