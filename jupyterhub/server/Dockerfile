FROM jupyterhub/k8s-hub:ac54cf1

USER root
COPY dataporten.py /usr/local/lib/python3.6/dist-packages/oauthenticator/
COPY jupyterhub_config.py /srv/

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
    APP_GID=999 \
    PKG_JUPYTERHUB_VERSION=0.9.2

RUN pip3 install --no-cache-dir cryptography==2.3
RUN groupadd -g "$APP_GID" notebook && \
    useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
    chown -R notebook:notebook /srv

ENV HOME=/home/notebook \
    XDG_CACHE_HOME=/home/notebook/.cache/

USER notebook
