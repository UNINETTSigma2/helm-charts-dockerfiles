#!/bin/bash

PGBIN=/usr/lib/postgresql/10/bin

# Set home
home=/home/${SYSTEM_USER}

# -w waits until server is up
PSQL_START_CMD="${PGBIN}/pg_ctl --timeout=180 -w -D ${home}/.postgresql -l ${home}/.postgresql/logfile start"
PSQL_STOP_CMD="${PGBIN}/pg_ctl -w -D ${home}/.postgresql stop"
PSQL_STATUS_CMD="${PGBIN}/pg_ctl -D ${home}/.postgresql status"

# make DB directory, if not existent
if [ ! -d ${home}/.postgresql ]; then
   mkdir ${home}/.postgresql
   ${PGBIN}/initdb -D ${home}/.postgresql
   echo "unix_socket_directories = '${home}/.postgresql'" >> ${home}/.postgresql/postgresql.conf
   ${PSQL_START_CMD}

# else don't
else
    # Fix problem with kubernetes cluster that adds rws permissions to the group
    # for more details see: https://github.com/materialscloud-org/aiidalab-z2jh-eosc/issues/5
    chmod g-rwxs ${home}/.postgresql -R

    # stores return value in $?
    running=true
    ${PSQL_STATUS_CMD} || running=false

    # Postgresql was probably not shutdown properly. Cleaning up the mess...
    if ! $running ; then
       echo "" > ${home}/.postgresql/logfile # empty log files
       rm -vf ${home}/.postgresql/.s.PGSQL.5432
       rm -vf ${home}/.postgresql/.s.PGSQL.5432.lock
       rm -vf ${home}/.postgresql/postmaster.pid
       ${PSQL_START_CMD}
   fi
fi
