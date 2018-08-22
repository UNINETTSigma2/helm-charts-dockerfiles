# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# All Spark: https://github.com/jupyter/docker-stacks/tree/8ccdfc1da8d5/all-spark-notebook/Dockerfile
# PySpark: https://github.com/jupyter/docker-stacks/tree/8ccdfc1da8d5/pyspark-notebook/Dockerfile
# SciPy: https://github.com/jupyter/docker-stacks/tree/8ccdfc1da8d5/scipy-notebook/Dockerfile
# Minimal: https://github.com/jupyter/docker-stacks/tree/8ccdfc1da8d5/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/tree/8ccdfc1da8d5/base-notebook/Dockerfile

FROM jupyter/all-spark-notebook:8ccdfc1da8d5

LABEL maintainer Uninett As <system@uninett.no>

USER root
RUN apt update && apt-get install --no-install-recommends -y \
    openssh-client=1:7.6p1-4 \
    nano=2.9.3-2 \
    htop=2.1.0-3 \
    less=487-0.1 \
    net-tools=1.60+git20161116.90da8a0-1ubuntu1 \
    man-db=2.8.3-2 \
    iputils-ping=3:20161105-1ubuntu2 \
    screen=4.6.2-1 \
    tmux=2.6-3 \
    liblapack-dev=3.7.1-4ubuntu1 \
    libopenblas-dev=0.2.20+ds-4 \
    graphviz=2.40.1-2 \
    cmake=3.10.2-1ubuntu2 \
    rsync=3.1.2-2.1ubuntu1 \
    p7zip-full=16.02+dfsg-6 \
    unrar=1:5.5.8-1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup locales
ENV TZ="Europe/Oslo"

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=5.5.x \
	PKG_SPARK_VERSION=2.3.1 \
	PKG_HADOOP_VERSION=2.7 \
	PKG_TOREE_VERSION=0.2.0-incubating-rc5 \
	PKG_SPYLON_VERSION=0.4.x \
	PKG_R_VERSION=3.4.1

RUN groupadd -g "$APP_GID" notebook && \
	useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
	usermod -G users notebook

ENV HOME=/home/notebook \
    PATH=$PATH:$SPARK_HOME/bin \
    XDG_CACHE_HOME=/home/notebook/.cache/

COPY start-*.sh /usr/local/bin/
COPY mem_parser.py /usr/local/bin/
COPY --chown=notebook:notebook spark-defaults.conf /usr/local/spark/conf/
RUN chown notebook:notebook -R "$CONDA_DIR/bin"


USER notebook

#hadolint ignore=DL3013
RUN conda install --quiet --yes -c conda-forge \
    'jupyter_contrib_nbextensions=0.5.0' \
    'tqdm=4.24*' \
    'yapf=0.22*' \
    'nbdime=1.0*' \
    'altair=2.1*' \
    'nbconvert=5.3*' && \
    conda install --quiet --yes -c damianavila82 'rise=5.3.*' && \
    conda clean -tipsy && \
    jupyter labextension install \
    '@jupyterlab/github@0.9.0' \
    '@jupyterlab/toc@0.4.0'  && \
    pip install jupyterlab-discovery==5.1.2 \
    jupyterlab-github==0.6.1 && \
    git clone https://github.com/paalka/nbresuse /tmp/nbresuse && pip install /tmp/nbresuse/ && \
    jupyter serverextension enable --py nbresuse --sys-prefix && \
    jupyter nbextension install --py nbresuse --sys-prefix && \
    jupyter nbextension enable --py nbresuse --sys-prefix && \
    jupyter lab build

COPY --chown=notebook:notebook .jupyter/ $HOME/.jupyter/
RUN chmod go+w -R "$HOME" /usr/local/spark/conf/spark-defaults.conf && \
    mkdir /tmp/spark-master /tmp/spark-worker && chmod go+w /tmp/spark-*

CMD ["/usr/local/bin/start-notebook.sh"]
