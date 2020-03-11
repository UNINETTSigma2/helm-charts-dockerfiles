#!/bin/bash -x

# Create a directory unique to this installation that can be used to
# store application specific settings
mkdir -p "$(/opt/get-app-dir.sh)"

# If a custom home directory is created for this user, then use this as the home folder
# Unfortunately, Jupyter double encodes the Jupyterhub username when mounting the home directory,
# so we have to be somewhat creative in order to actually find the correct home folder.
for d in /home/*; do
  foldername=${d##*/}

  # Remove the extra 2d's added by the double encoding
  foldername=$(echo $foldername | sed 's/-2d/-/g' -)

  if [[ "$JUPYTERHUB_USER" == *$foldername ]]; then
    mv /home/notebook /home/old-notebook
    ln -s "$d" /home/notebook
    break
  fi
done

