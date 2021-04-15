#!/bin/bash -e

# Debugging.
set -x

# Environment.
export SHELL=/bin/bash

# Set home
home=/home/${SYSTEM_USER}

export JUPYTER_CONFIG_DIR=$home/.config/jupyter
export JUPYTER_DATA_DIR=$home/.config/jupyter/data
export JUPYTER_RUNTIME_DIR=$home/.config/jupyter/runtime
export IPYTHONDIR=$home/.config/ipython
export AIIDA_PATH="$home/.aiida"

mkdir -p $JUPYTER_CONFIG_DIR $JUPYTER_DATA_DIR $JUPYTER_RUNTIME_DIR $IPYTHONDIR

export AIIDALAB_HOME=$home
export PYTHONPATH=$home
export AIIDALAB_APPS=$home/apps

# Enter home folder and start jupyterhub-singleuser.
cd $home

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
  /usr/bin/python3 /opt/aiidalab-singleuser                           \
      --ip=0.0.0.0                                                   \
      --port=8888                                                    \
      --notebook-dir="/home/${SYSTEM_USER}"                          \
      --VoilaConfiguration.template=aiidalab                         \
      --VoilaConfiguration.enable_nbextensions=True                  \
      --NotebookApp.iopub_data_rate_limit=1000000000                 \
      --NotebookApp.default_url="/apps/apps/home/start.ipynb"
else

  # Otherwise launch notebook server directly.
  /usr/local/bin/jupyter-notebook                                    \
      --ip=0.0.0.0                                                   \
      --port=8888                                                    \
      --no-browser                                                   \
      --notebook-dir="/home/${SYSTEM_USER}"                          \
      --VoilaConfiguration.template=aiidalab                         \
      --VoilaConfiguration.enable_nbextensions=True                  \
      --NotebookApp.default_url="/apps/apps/home/start.ipynb"
fi


