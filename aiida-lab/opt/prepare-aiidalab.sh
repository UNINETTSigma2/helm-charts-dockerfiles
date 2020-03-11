#!/bin/bash -e

# Debugging.
set -x

# Environment.
export SHELL=/bin/bash
APP_DIR="$(/opt/get-app-dir.sh)"

export AIIDA_PATH="$APP_DIR/.aiida"


# Setup CP2K code.
computer_name=localhost
code_name=cp2k
verdi code show ${code_name}@${computer_name} || verdi code setup \
    --non-interactive                                             \
    --label ${code_name}                                          \
    --description "cp2k v5.1 in AiiDA lab container."             \
    --input-plugin cp2k                                           \
    --computer ${computer_name}                                   \
    --remote-abs-path `which cp2k.popt`

# Setup Quantum ESPRESSO pw.x code.
code_name=pw
verdi code show ${code_name}@${computer_name} || verdi code setup \
    --non-interactive                                             \
    --label ${code_name}                                          \
    --description "pw.x v.6.0 in AiiDA lab container."            \
    --input-plugin quantumespresso.pw                             \
    --computer ${computer_name}                                   \
    --remote-abs-path `which pw.x`

# Setup pseudopotentials.
if [ ! -f "${APP_DIR}/SKIP_IMPORT_PSEUDOS" ]; then
   verdi import -n /opt/pseudos/SSSP_efficiency_pseudos.aiida
   verdi import -n /opt/pseudos/SSSP_precision_pseudos.aiida
   touch ${APP_DIR}/SKIP_IMPORT_PSEUDOS
fi

# Setup AiiDA jupyter extension.
# Don't forget to copy this file to .ipython/profile_default/startup/
# aiida/tools/ipython/aiida_magic_register.py
IPYTHONDIR=$APP_DIR/.config/ipython
if [ ! -e $IPYTHONDIR/profile_default/startup/aiida_magic_register.py ]; then
   mkdir -p $IPYTHONDIR/profile_default/startup/
   cat << EOF > $IPYTHONDIR/profile_default/startup/aiida_magic_register.py
if __name__ == "__main__":

    try:
        import aiida
        del aiida
    except ImportError:
        pass
    else:
        import IPython
        # pylint: disable=ungrouped-imports
        from aiida.tools.ipython.ipython_magics import load_ipython_extension

        # Get the current Ipython session
        IPYSESSION = IPython.get_ipython()

        # Register the line magic
        load_ipython_extension(IPYSESSION)
EOF
fi

# Install/upgrade apps.
if [ ! -e ${APP_DIR}/apps ]; then

  # Create apps folder and make it importable from python.
  mkdir ${APP_DIR}/apps
  touch ${APP_DIR}/apps/__init__.py

  # First install the home app.
  git clone https://github.com/aiidalab/aiidalab-home ${APP_DIR}/apps/home
  cd ${APP_DIR}/apps/home
  git checkout ${AIIDALAB_DEFAULT_GIT_BRANCH}
  cd -

  # Define the order how the apps should appear.
  echo '{
    "hidden": [],
    "order": [
      "aiidalab-widgets-base",
      "quantum-espresso"
    ]
  }' > ${APP_DIR}/apps/home/.launcher.json

  git clone https://github.com/aiidalab/aiidalab-widgets-base ${APP_DIR}/apps/aiidalab-widgets-base
  cd ${APP_DIR}/apps/aiidalab-widgets-base
  git checkout ${AIIDALAB_DEFAULT_GIT_BRANCH}
  cd -

  git clone https://github.com/aiidalab/aiidalab-qe.git ${APP_DIR}/apps/quantum-espresso
  cd ${APP_DIR}/apps/quantum-espresso
  git checkout ${AIIDALAB_DEFAULT_GIT_BRANCH}
 cd -
fi

# Since aiidalab-home reaches the notebook base path using hardcoded relative path traversers (i.e. ../../'s),
# we have to add more of these in order to ensure that the correct notebook base path is actually reached.
sed -i 's${jupbase}$../../{jupbase}$g' ${APP_DIR}/apps/home/start.py
