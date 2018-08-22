#!/bin/bash

set -e

echo "Starting RSudio Server"
echo "session-default-working-dir=/home/$USERNAME" >> /etc/rstudio/rsession.conf

if [ ! -e "$HOME/.Renviron" ]; then
	echo -e "HOME=/home/$USERNAME\nUSER=$USERNAME\nTZ=Europe/Oslo" > "$HOME/.Renviron"
fi

/usr/lib/rstudio-server/bin/rserver --server-daemonize 0 --auth-none 0 &

if [ -n "$SHINY_APPS_PATH" ]; then
	if [ ! -d "$SHINY_APPS_PATH" ]; then
		echo "Initialising Shiny App directory"
		mkdir -p "$SHINY_APPS_PATH"
		cp -r /srv/shiny-server/* $SHINY_APPS_PATH
        if [ -L $SHINY_APPS_PATH/sample-apps ]; then
		    rm -rf $SHINY_APPS_PATH/sample-apps
		    cp -r /opt/shiny-server/samples/sample-apps $SHINY_APPS_PATH/sample-apps
		fi
        if [ -L $SHINY_APPS_PATH/index.html ]; then
		    rm $SHINY_APPS_PATH/index.html
		    cp /opt/shiny-server/samples/welcome.html $SHINY_APPS_PATH/index.html
		fi
	fi
	echo "Updating Shiny server directory path"
	rm -rf /srv/shiny-server
	ln -s $SHINY_APPS_PATH /srv
fi

# If we have shared data mounted, the link it to current directory to have it visible in notebook
if [ -d "$PVC_MOUNT_PATH" ]; then
	rm -f "$HOME/data"
	ln -sf "$PVC_MOUNT_PATH" "$HOME/data"
fi

echo "Starting Shiny Server"
shiny-server > /var/log/shiny-server/server.log &

sleep inf
