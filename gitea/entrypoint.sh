#!/bin/bash

#for FOLDER in /data/gitea/conf /data/gitea/log /data/git /data/ssh; do
#    mkdir -p ${FOLDER}
#done


[[ -f /etc/s6/gitea/setup ]] && source /etc/s6/gitea/setup

pushd /app/gitea > /dev/null
#    exec su-exec $USER /app/gitea/gitea web
GITEA_CUSTOM=/etc/gitea /app/gitea/gitea web --config /etc/gitea/app.ini
popd

