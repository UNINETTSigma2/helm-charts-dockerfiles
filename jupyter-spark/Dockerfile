# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# All Spark: https://github.com/jupyter/docker-stacks/tree/4ebeb1f2d154/all-spark-notebook/Dockerfile
# PySpark: https://github.com/jupyter/docker-stacks/tree/4ebeb1f2d154/pyspark-notebook/Dockerfile
# SciPy: https://github.com/jupyter/docker-stacks/tree/4ebeb1f2d154/scipy-notebook/Dockerfile
# Minimal: https://github.com/jupyter/docker-stacks/tree/4ebeb1f2d154/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/tree/4ebeb1f2d154/base-notebook/Dockerfile

FROM jupyter/all-spark-notebook:4ebeb1f2d154

LABEL maintainer Uninett As <system@uninett.no>

# hadolint ignore=DL3002
USER root
RUN apt update && apt-get install --no-install-recommends -y \
    openssh-client=1:7.2p2-4ubuntu2.4 \
    nano=2.5.3-2ubuntu2 \
    htop=2.0.1-1ubuntu1 \
    less=481-2.1ubuntu0.2 \
    net-tools=1.60-26ubuntu1 \
    man-db=2.7.5-1 \
    iputils-ping=3:20121221-5ubuntu2 \
    rsync=3.1.1-3ubuntu1.2 && \
 	apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup locales
ENV TZ="Europe/Oslo"

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=5.4.x \
	PKG_SPARK_VERSION=2.3.0 \
	PKG_HADOOP_VERSION=2.7 \
	PKG_TOREE_VERSION=0.2.0-incubating-rc5 \
	PKG_SPYLON_VERSION=0.4.x \
	PKG_R_VERSION=3.4.1

# hadolint ignore=SC2086
RUN groupadd -g $APP_GID notebook && \
	useradd -m -s /bin/bash -N -u $APP_UID -g notebook notebook && \
	chmod go+w -R /home/notebook $CONDA_DIR

ENV HOME=/home/notebook \
    PATH=$PATH:$SPARK_HOME/bin \
    XDG_CACHE_HOME=/home/notebook/.cache/

COPY start-*.sh /usr/local/bin/
COPY --chown=notebook:notebook spark-defaults.conf /usr/local/spark/conf/
USER notebook

RUN conda install --quiet --yes -c conda-forge \
    'jupyter_contrib_nbextensions=0.5.0' \
    'tqdm=4.23*' \
    'yapf=0.22*' \
    'nbdime=1.0*' \
    'altair=2.0*' \
    'nbconvert=5.3*' && \
    conda clean -tipsy && \
    jupyter labextension install \
    'nbdime-jupyterlab@0.2.0' \
    '@ijmbarr/jupyterlab_spellchecker@0.1.1' \
    '@jupyterlab/github@0.7.2' \
    'jupyterlab-toc@0.2.1'  && \
    pip install jupyterlab-discovery==5.1.1 jupyterlab-github==0.6.0 && \
    jupyter lab build

COPY --chown=notebook:notebook .jupyter/ $HOME/.jupyter
WORKDIR $HOME
CMD ["/usr/local/bin/start-notebook.sh"]
