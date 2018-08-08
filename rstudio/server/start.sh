#!/bin/bash

set -e

echo "Starting RSudio Server"
/usr/lib/rstudio-server/bin/rserver --server-daemonize 0 --auth-none 0 &

if [ -n "$SHINY_APPS_PATH" ]; then
	echo "Updating Shiny server directory path"
	cp -r /srv/shiny-server/* $SHINY_APPS_PATH
	rm $SHINY_APPS_PATH/sample-apps
	rm $SHINY_APPS_PATH/index.html
	cp -r /opt/shiny-server/samples/sample-apps $SHINY_APPS_PATH/sample-apps
	cp  /opt/shiny-server/samples/welcome.html $SHINY_APPS_PATH/index.html
	rm -rf /srv/shiny-server
	ln -s $SHINY_APPS_PATH /srv
fi

echo "Starting Shiny Server"
shiny-server > /var/log/shiny-server/server.log &

sleep inf
