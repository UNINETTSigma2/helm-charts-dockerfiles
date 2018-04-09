#!/bin/bash
set -e

: ${ETHERPAD_TITLE:=Etherpad}
: ${ETHERPAD_PORT:=9001}

if [ ! -f settings.json ]; then

	cat <<- EOF > settings.json
	{
		"title": "${ETHERPAD_TITLE}",
		"ip": "0.0.0.0",
		"port" :${ETHERPAD_PORT},
		"dbType" : "dirty",
		"dbSettings" : {
			"filename" : "var/dirty.db"
		},
	}
	EOF

fi

exec "$@"
