#!/bin/bash

PGBIN=/usr/lib/postgresql/10/bin

APP_DIR="$(/opt/get-app-dir.sh)"
# -w waits until server is up
PSQL_START_CMD="${PGBIN}/pg_ctl --timeout=180 -w -D ${APP_DIR}/.postgresql -l ${APP_DIR}/.postgresql/logfile start"
PSQL_STOP_CMD="${PGBIN}/pg_ctl -w -D ${APP_DIR}/.postgresql stop"
PSQL_STATUS_CMD="${PGBIN}/pg_ctl -D ${APP_DIR}/.postgresql status"

# make DB directory, if not existent
if [ ! -d ${APP_DIR}/.postgresql ]; then
   mkdir ${APP_DIR}/.postgresql
   ${PGBIN}/initdb -D ${APP_DIR}/.postgresql
   echo "unix_socket_directories = '${APP_DIR}/.postgresql'" >> ${APP_DIR}/.postgresql/postgresql.conf
   ${PSQL_START_CMD}

# else don't
else
    # Fix problem with kubernetes cluster that adds rws permissions to the group
    # for more details see: https://github.com/materialscloud-org/aiidalab-z2jh-eosc/issues/5
    chmod g-rwxs ${APP_DIR}/.postgresql -R

    # stores return value in $?
    running=true
    ${PSQL_STATUS_CMD} || running=false

    # Postgresql was probably not shutdown properly. Cleaning up the mess...
    if ! $running ; then
       echo "" > ${APP_DIR}/.postgresql/logfile # empty log files
       rm -vf ${APP_DIR}/.postgresql/.s.PGSQL.5432
       rm -vf ${APP_DIR}/.postgresql/.s.PGSQL.5432.lock
       rm -vf ${APP_DIR}/.postgresql/postmaster.pid
       ${PSQL_START_CMD}
   fi
fi
