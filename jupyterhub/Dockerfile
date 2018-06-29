FROM jupyterhub/k8s-hub:36a8dcb

# hadolint ignore=DL3002
USER root
COPY dataporten.py /usr/local/lib/python3.6/dist-packages/oauthenticator/
COPY jupyterhub_config.py /srv/

USER jovyan