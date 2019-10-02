#!/bin/bash

set -e

# Exec the specified command or fall back on bash
if [ $# -eq 0 ]; then
    cmd=bash
else
    cmd=$*
fi

if [ ! -d "$HOME/.jupyter" ]; then
	cp -r "/opt/.jupyter" "$HOME/.jupyter"
fi

if [ ! -f "$HOME/.jupyter/notebook_config.py" ]; then
	cp -r "/opt/.jupyter/notebook_config.py" "$HOME/.jupyter"
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


if [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
	jupyter-labhub --config "$HOME/.jupyter/notebook_config.py"
else
	jupyterhub-singleuser --config "$HOME/.jupyter/notebook_config.py"
fi
