FROM jupyterhub/k8s-hub:0.9.0

USER root
COPY dataporten.py /usr/local/lib/python3.6/dist-packages/oauthenticator/
COPY z2jh.py jupyterhub_config.py /srv/

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
    APP_GID=999 \
    PKG_JUPYTERHUB_VERSION=1.1.*

RUN groupadd -g "$APP_GID" notebook && \
    useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
    chown -R notebook:notebook /srv && chmod go+w -R /srv

ENV HOME=/home/notebook \
    XDG_CACHE_HOME=/home/notebook/.cache/

USER notebook
