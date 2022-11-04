FROM jupyterhub/k8s-hub:2.0.0

USER root
# paste directory needs to include the python version number used in k8s-hub
COPY dataporten.py /usr/local/lib/python3.8/dist-packages/oauthenticator/
COPY z2jh.py jupyterhub_config.py /srv/

RUN mkdir -p /usr/local/etc/jupyterhub/config /usr/local/etc/jupyterhub/secret && \
    chmod -R go+w /usr/local/etc/jupyterhub/config /usr/local/etc/jupyterhub/secret

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
    APP_GID=999 \
    PKG_JUPYTERHUB_VERSION=1.1.*

RUN groupadd -g "$APP_GID" notebook && \
    useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
    chown -R notebook:notebook /srv && chmod go+w -R /srv

ENV HOME=/home/notebook \
    XDG_CACHE_HOME=/home/notebook/.cache/
RUN apt-get update && apt-get upgrade -y

USER notebook
