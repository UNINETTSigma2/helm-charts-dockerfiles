#!/bin/bash

set -e

echo "Starting RSudio Server"
/usr/lib/rstudio-server/bin/rserver --server-daemonize 0 --auth-none 0 &

if [ -n "$SHINY_APPS_PATH" ]; then
	echo "Updating Shiny server directory path"
	if [ ! -e $SHINY_APPS_PATH/sample-apps ]; then
	    cp -r /srv/shiny-server/* $SHINY_APPS_PATH
	fi

        if [ -L $SHINY_APPS_PATH/sample-apps ]; then
	    rm -rf $SHINY_APPS_PATH/sample-apps
	    cp -r /opt/shiny-server/samples/sample-apps $SHINY_APPS_PATH/sample-apps
	fi
        if [ -L $SHINY_APPS_PATH/index.html ]; then
	    rm $SHINY_APPS_PATH/index.html
	    cp /opt/shiny-server/samples/welcome.html $SHINY_APPS_PATH/index.html
	fi

	rm -rf /srv/shiny-server
	ln -s $SHINY_APPS_PATH /srv
fi

echo "Starting Shiny Server"
shiny-server > /var/log/shiny-server/server.log &

sleep inf
