#!/bin/bash

set -e

echo "Starting RSudio Server"
/usr/lib/rstudio-server/bin/rserver --server-daemonize 0 --auth-none 0 &

if [ -n "$SHINY_APPS_PATH" ]; then
	echo "Updating Shiny server directory path"
	cp -r /srv/shiny-server/* $SHINY_APPS_PATH
	rm -rf /srv/shiny-server
	ln -s $SHINY_APPS_PATH /srv
fi

echo "Starting Shiny Server"
shiny-server > /var/log/shiny-server/server.log &

sleep inf
