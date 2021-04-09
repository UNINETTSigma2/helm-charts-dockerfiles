#!/bin/bash -e

# Debugging.
set -x

# Environment.
export SHELL=/bin/bash

APP_DIR="$(/opt/get-app-dir.sh)"
RELEASE_NAME="${RELEASE_NAME:-aiidalab}"

export JUPYTER_CONFIG_DIR=$APP_DIR/.config/jupyter
export JUPYTER_DATA_DIR=$APP_DIR/.config/jupyter/data
export JUPYTER_RUNTIME_DIR=$APP_DIR/.config/jupyter/runtime
export IPYTHONDIR=$APP_DIR/.config/ipython
export AIIDA_PATH="$APP_DIR/.aiida"

mkdir -p $JUPYTER_CONFIG_DIR $JUPYTER_DATA_DIR $JUPYTER_RUNTIME_DIR $IPYTHONDIR

export AIIDALAB_HOME=$APP_DIR
export PYTHONPATH=$APP_DIR
export AIIDALAB_APPS=$APP_DIR/apps

# Enter home folder and start jupyterhub-singleuser.
cd /home/${SYSTEM_USER}

home=/home/${SYSTEM_USER}

# If we have shared data directories mounted, make the folders available in the users home directory.
if [ -d "/mnt" ]; then
    for dir in /mnt/*/; do
      if [ -d "$dir" ]; then
        dirname=${dir%*/}     # remove the trailing "/"
        dirname=${dirname##*/}    # everything after the final "/"

        if [ -L "$home/shared-$dirname" ]; then
          rm -f "$home/shared-$dirname"
        fi

        ln -sf "/mnt/$dirname" "$home/shared-$dirname"
      fi
    done
fi

if [[ ! -z "${JUPYTERHUB_API_TOKEN}" ]]; then

  # Launched by JupyterHub, use single-user entrypoint.
  /opt/conda/bin/python /opt/aiidalab-singleuser                     \
      --ip=0.0.0.0                                                   \
      --port=8888                                                    \
      --notebook-dir="/home/${SYSTEM_USER}"                          \
      --NotebookApp.iopub_data_rate_limit=1000000000                 \
      --NotebookApp.default_url="/apps/.tools/$RELEASE_NAME/apps/home/start.ipynb"
else

  # Otherwise launch notebook server directly.
  jupyter-notebook                                                   \
      --ip=0.0.0.0                                                   \
      --port=8888                                                    \
      --no-browser                                                   \
      --notebook-dir="/home/${SYSTEM_USER}"                          \
      --NotebookApp.default_url="/apps/.tools/$RELEASE_NAME/apps/home/start.ipynb"
fi


