#!/bin/bash

set -e

# Since the name of the volume is escaped wrongly, we have to wrongly escape the
# usename elsewhere as well.
# https://github.com/jupyterhub/kubespawner/pull/309
REAL_JUPYTERHUB_USER=$JUPYTERHUB_USER
if [ -n "$JUPYTERHUB_USER" ]; then
  JUPYTERHUB_USER=$(python /usr/local/bin/normalize-username.py $JUPYTERHUB_USER)
fi

HOME=$(eval echo "$HOME")
JUPYTERHUB_USER=$REAL_JUPYTERHUB_USER # Swich back after expanding, as Jupyterhub breaks otherwise.

mkdir -p "$HOME"
mv /home/notebook /home/oldnotebook
ln -s "$HOME" /home/notebook

# Exec the specified command or fall back on bash
if [ $# -eq 0 ]; then
    cmd=bash
else
    cmd=$*
fi

if [ ! -d "$HOME/.jupyter" ]; then
	cp -r "/opt/.jupyter" "$HOME/.jupyter"
fi

if [ -f "/tmp/ipcontroller-client.json" ]; then
  mkdir -p "$HOME/.ipython/profile_default/security/"
  ls -lah "$HOME/.ipython/profile_default/security/"
  cp "/tmp/ipcontroller-client.json" "$HOME/.ipython/profile_default/security/" || true
fi

if [ ! -f "$HOME/.jupyter/jupyter_server_config.py" ]; then
	cp -r "/opt/.jupyter/jupyter_server_config.py" "$HOME/.jupyter"
fi

# If we have shared data directories mounted, make the folders available in the users home directory.
if [ -d "/mnt" ]; then
    for dir in /mnt/*/; do
      if [ -d "$dir" ]; then
        dirname=${dir%*/}     # remove the trailing "/"
        dirname=${dirname##*/}    # everything after the final "/"
        if [ -L "$HOME/shared-$dirname" ]; then
          rm -f "$HOME/shared-$dirname"
        fi

        ln -sf "/mnt/$dirname" "$HOME/shared-$dirname"
      fi
    done
fi


cd "$HOME"
if [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
  jupyterhub-singleuser --config "$HOME/.jupyter/jupyter_server_config.py" --SingleUserLabApp.default_url="/lab"
else
  jupyterhub-singleuser --config "$HOME/.jupyter/jupyter_server_config.py" --SingleUserLabApp.default_url="/tree"
fi
