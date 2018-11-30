#!/bin/bash

set -e

# Exec the specified command or fall back on bash
if [ $# -eq 0 ]; then
    cmd=bash
else
    cmd=$*
fi

if [ ! -d "$HOME/.jupyter" ]; then
	cp -r /opt/.jupyter $HOME/.jupyter
fi

# If we have shared data mounted, the link it to current directory to have it visible in notebook
if [ -d "/mnt/data" ]; then
	rm -f $HOME/data
	ln -sf /mnt/data $HOME/data
fi


if [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
	jupyter-labhub --config "$HOME/.jupyter/notebook_config.py" &
else
	jupyterhub-singleuser --config "$HOME/.jupyter/notebook_config.py" &
fi
