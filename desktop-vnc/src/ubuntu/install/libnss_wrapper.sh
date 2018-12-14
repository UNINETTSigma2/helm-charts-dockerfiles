#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

# have to be added to hold all env vars correctly
echo 'source $STARTUPDIR/generate_container_user' >> $HOME/.bashrc
