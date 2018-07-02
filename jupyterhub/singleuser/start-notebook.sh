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

jupyterhub-singleuser --config $HOME/.jupyter/notebook_config.py