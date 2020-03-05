#!/bin/bash -e

#
# Copied from https://github.com/aiidateam/aiida-docker-stack/blob/master/opt/start-singleuser.sh
#
# This script is executed whenever the docker container is (re)started.

#===============================================================================
# debugging
set -x

#===============================================================================
# environment
export SHELL=/bin/bash

#===============================================================================
# setup AiiDA
aiida_backend=django

if [ ! -d /home/aiida/.aiida ]; then
    verdi setup                                \
        --profile default                      \
        --non-interactive                      \
        --email some.body@xyz.com              \
        --first-name Some                      \
        --last-name Body                       \
        --institution XYZ                      \
        --db-backend $aiida_backend            \
        --db-username $AIIDA_DB_USER           \
        --db-password $AIIDA_DB_PASSWD         \
        --db-name $AIIDA_DB_NAME               \
        --db-host $AIIDA_DB_HOST               \
        --db-port 5432                         \
        --repository /home/aiida/aiida_repository

   verdi profile setdefault default
fi

#===============================================================================
# perform the database migration if needed
#
verdi daemon start || ( verdi daemon stop && verdi database migrate --force )
verdi daemon stop

#===============================================================================
# setup local computer

computer_name=localhost
verdi computer show $computer_name || verdi computer setup \
    --non-interactive                                      \
    --label ${computer_name}                               \
    --description "this computer"                          \
    --hostname ${computer_name}                            \
    --transport local                                      \
    --scheduler direct                                     \
    --work-dir /home/aiida/aiida_run/                      \
    --mpirun-command "mpirun -np {tot_num_mpiprocs}"       \
    --mpiprocs-per-machine 1 &&                            \
    verdi computer configure local ${computer_name}        \
    --non-interactive                                      \
    --safe-interval 0.0

#EOF
