#!/bin/bash

# This script is executed whenever the docker container is (re)started.

# Debugging.
set -x

# Environment.
export SHELL=/bin/bash

# Update the list of installed aiida plugins.
reentry scan

# Setup AiiDA autocompletion.
grep _VERDI_COMPLETE /home/${SYSTEM_USER}/.bashrc &> /dev/null || echo 'eval "$(_VERDI_COMPLETE=source verdi)"' >> /home/${SYSTEM_USER}/.bashrc

# Check if user requested to set up AiiDA profile (and if it exists already)
if [[ ${SETUP_DEFAULT_PROFILE} == true ]] && ! verdi profile show ${PROFILE_NAME} &> /dev/null; then
    NEED_SETUP_PROFILE=true;
else
    NEED_SETUP_PROFILE=false;
fi

# Setup AiiDA profile if needed.
if [[ ${NEED_SETUP_PROFILE} == true ]]; then
    verdi setup \
        --profile default                      \
        --non-interactive                      \
        --email some.body@xyz.com              \
        --first-name Some                      \
        --last-name Body                       \
        --institution XYZ                      \
        --db-backend django                    \
        --db-username $AIIDA_DB_USER           \
        --db-password $AIIDA_DB_PASSWD         \
        --db-name $AIIDA_DB_NAME               \
        --db-host $AIIDA_DB_HOST               \
        --db-port 5432                         \
        --repository /home/aiida/aiida_repository

   verdi profile setdefault default

    # Setup and configure local computer.
    computer_name=localhost
    verdi computer show ${computer_name} || verdi computer setup   \
        --non-interactive                                          \
        --label "${computer_name}"                                 \
        --description "this computer"                              \
        --hostname "${computer_name}"                              \
        --transport local                                          \
        --scheduler direct                                         \
        --work-dir /home/aiida/aiida_run/                          \
        --mpirun-command "mpirun -np {tot_num_mpiprocs}"           \
        --mpiprocs-per-machine 1 &&                                \
    verdi computer configure local "${computer_name}"              \
        --non-interactive                                          \
        --safe-interval 0.0
fi


# Show the default profile
verdi profile show || echo "The default profile is not set."

# Make sure that the daemon is not running, otherwise the migration will abort.
verdi daemon stop

# Migration will run for the default profile.
verdi database migrate --force || echo "Database migration failed."

# Daemon will start only if the database exists and is migrated to the latest version.
verdi daemon start || echo "AiiDA daemon is not running."
