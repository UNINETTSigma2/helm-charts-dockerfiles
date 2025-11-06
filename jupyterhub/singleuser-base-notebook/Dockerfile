# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# Minimal: https://github.com/jupyter/docker-stacks/tree/d400e383cc1d/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/tree/d400e383cc1d/base-notebook/Dockerfile



FROM quay.io/jupyter/base-notebook:47423b6d549e as miniconda
USER root
RUN conda config --set channel_priority strict && \
    mamba install --quiet --yes -c conda-forge \
    'jupyter-server-proxy==4.4.0' \
    'escapism==1.0.1' \
    'jupyterlab-github==4.0.0' && \
    mamba clean --all -f -y
USER notebook

FROM quay.io/jupyter/base-notebook:47423b6d549e

LABEL maintainer="contact@sigma2.no"
USER root

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=7.4.7
RUN groupadd -g "$APP_GID" notebook && \
    useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
    usermod -G users notebook && chmod go+rwx -R "$CONDA_DIR/bin"
COPY --chown=notebook:notebook --from=miniconda $CONDA_DIR $CONDA_DIR

SHELL ["/bin/bash", "-o", "pipefail", "-c"]


RUN apt-get update && apt-get install -y --no-install-recommends \
	openssh-client \
    curl \
	less \
	net-tools \
	man-db \
	iputils-ping \
	screen \
	tmux \
	graphviz \
	cmake \
	rsync \
	p7zip-full \
	tzdata \
	vim \
	unrar \
	ca-certificates \
    sudo \
    inkscape \
    "openmpi-bin" && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime


ENV TZ="Europe/Oslo" \
    HOME=/home/notebook \
    XDG_CACHE_HOME=/home/notebook/.cache/

COPY normalize-username.py start-notebook.sh /usr/local/bin/
COPY --chown=notebook:notebook .jupyter/ /opt/.jupyter/
RUN mkdir -p /home/notebook/.ipython/profile_default/security/ && chmod go+rwx -R "$CONDA_DIR/bin" && chown notebook:notebook -R "$CONDA_DIR/bin" "$HOME" && \
    mkdir -p "$CONDA_DIR/.condatmp" && chmod go+rwx "$CONDA_DIR/.condatmp" && chown notebook:notebook "$CONDA_DIR"

RUN chmod go+w -R "$HOME" && chmod o+w /home && rm -r /home/notebook

USER notebook
WORKDIR $HOME
CMD ["/usr/local/bin/start-notebook.sh"]
