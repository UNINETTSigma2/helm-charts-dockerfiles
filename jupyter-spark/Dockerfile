# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# All Spark: https://github.com/jupyter/docker-stacks/tree/42f4c82a07ff/all-spark-notebook/Dockerfile
# PySpark: https://github.com/jupyter/docker-stacks/tree/42f4c82a07ff/pyspark-notebook/Dockerfile
# SciPy: https://github.com/jupyter/docker-stacks/tree/42f4c82a07ff/scipy-notebook/Dockerfile
# Minimal: https://github.com/jupyter/docker-stacks/tree/42f4c82a07ff/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/tree/42f4c82a07ff/base-notebook/Dockerfile

FROM jupyter/all-spark-notebook:42f4c82a07ff as miniconda
USER root
ENV DEBIAN_FRONTEND noninteractive \
    NB_UID=999 \
    NB_GID=999

RUN apt update && apt install -y eatmydata
RUN conda config --set channel_priority strict
RUN eatmydata conda update --all -y && eatmydata conda install --quiet --yes -c conda-forge \
    'tqdm=4.45*' \
    'yapf=0.29.0' \
    'nbdime=2.*' \
    'nbconvert=6.0*' \
    'plotly=4.6*' \
    'rise=5.6*' \
    'ipywidgets' \
    'jupyter-server-proxy' \
    && conda clean -tipsy

# Add a minimal conda environment in order to make it easier to add custom pages.
RUN conda create -n minimal -y && bash -c 'source activate minimal && conda install -y ipykernel && ipython kernel install --name=minimal --display-name="Python 3 (minimal conda)" && conda deactivate'

#hadolint ignore=DL3013
ENV NODE_OPTIONS --max-old-space-size=4096
RUN pip install ipyparallel==6.2.* cufflinks==0.14.* \
    jupyterlab_iframe==0.2.2 && \
    jupyter serverextension enable --py jupyter_server_proxy jupyterlab_iframe && \
    jupyter labextension install \
    '@jupyter-widgets/jupyterlab-manager' \
    'plotlywidget@4.6.0' \
    'jupyterlab-plotly@4.6.0' \
    '@jupyterlab/github' \
    'nbdime-jupyterlab' \
    '@jupyterlab/toc' \
    '@jupyterlab/server-proxy' \
    'jupyterlab_iframe' && \
    git clone https://github.com/paalka/nbresuse /tmp/nbresuse && pip install /tmp/nbresuse/ && \
    jupyter serverextension enable --py nbresuse --sys-prefix && \
    jupyter nbextension install --py nbresuse --sys-prefix && \
    jupyter nbextension enable --py nbresuse --sys-prefix && \
    jupyter lab build

RUN fix-permissions $CONDA_DIR

FROM jupyter/all-spark-notebook:42f4c82a07ff
LABEL maintainer Uninett As <system@uninett.no>

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    rm -rf /var/lib/apt/lists/*

# Refer here for versions https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/ubuntu18.04/10.1/base/Dockerfiles
# note that this uses Ubuntu 18.04.
#
# https://www.tensorflow.org/install/gpu
#  and
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu-jupyter.Dockerfile
# might also be useful for CUDA packages
#
# See  https://www.tensorflow.org/install/source#tested_build_configurations for a guide on which configurations that works
#
ENV PKG_CUDA_VERSION=11.0 \
    NCCL_VERSION=2.8.3 \
    PKG_CUDNN_VERSION=8.0.5.39-1

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-${PKG_CUDA_VERSION/./-} \
        cuda-toolkit-${PKG_CUDA_VERSION/./-} \
        curl \
        libcudnn8=${PKG_CUDNN_VERSION}+cuda${PKG_CUDA_VERSION} \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        software-properties-common \
        unzip \
        "openmpi-bin" && \
				ln -s "cuda-$PKG_CUDA_VERSION" /usr/local/cuda

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    ln -s /usr/local/cuda/include/* /usr/include/

RUN apt update && apt-get install --no-install-recommends -y \
    python3 \
    python3-dev \
    python3-venv \
    python3-pip \
    python3-wheel \
    python3-ipykernel \
    openssh-client=1:8.2p1-4ubuntu0.1 \
    nano=4.8-1ubuntu1 \
    htop=2.2.0-2build1 \
    less=551-1 \
    net-tools=1.60+git20180626.aebd88e-1ubuntu1 \
    man-db=2.9.1-1 \
    iputils-ping=3:20190709-3 \
    screen=4.8.0-1 \
    tmux \
    liblapack-dev=3.9.0-1build1 \
    libopenblas-dev=0.3.8+ds-1ubuntu0.20.04.1 \
    graphviz=2.42.2-3build2 \
    cmake \
    rsync=3.1.3-8 \
    p7zip-full=16.02+dfsg-7build1 \
    unrar=1:5.6.6-2build1 \
    vim && \
    apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Setup locales
ENV TZ="Europe/Oslo"

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=5.7.x \
	PKG_SPARK_VERSION=2.4.0 \
	PKG_HADOOP_VERSION=2.7 \
	PKG_TOREE_VERSION=0.3.0-incubating \
	PKG_R_VERSION=4.0.3 \
	PKG_VS_CODE_VERSION=3.7.2

RUN groupadd -g "$APP_GID" notebook && \
	useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
	usermod -G users notebook

ENV HOME=/home/notebook \
    PATH=$PATH:$SPARK_HOME/bin \
    XDG_CACHE_HOME=/home/notebook/.cache/

COPY start-*.sh /usr/local/bin/
COPY mem_parser.py /usr/local/bin/
COPY --chown=notebook:notebook spark-defaults.conf /usr/local/spark/conf/
COPY --chown=notebook:notebook --from=miniconda $CONDA_DIR $CONDA_DIR
COPY --chown=notebook:notebook --from=miniconda /usr/local/share/jupyter/kernels/minimal /usr/local/share/jupyter/kernels/minimal
RUN mkdir -p "$CONDA_DIR/.condatmp" && chmod go+rwx "$CONDA_DIR/.condatmp" /usr/local/spark/conf/spark-defaults.conf

RUN wget -q "https://github.com/cdr/code-server/releases/download/v$PKG_VS_CODE_VERSION/code-server-$PKG_VS_CODE_VERSION-linux-amd64.tar.gz"  && \
    tar zxf "code-server-$PKG_VS_CODE_VERSION-linux-amd64.tar.gz" && \
    mv "code-server-$PKG_VS_CODE_VERSION-linux-amd64/code-server" /usr/local/bin/ && \
    rm -rf "code-server-$PKG_VS_CODE_VERSION-linux-amd64/*" "$HOME/.wget-hsts" && locale-gen en_US.UTF-8

RUN chown notebook:notebook $CONDA_DIR "$CONDA_DIR/.condatmp"
COPY --chown=notebook:notebook .jupyter/ $HOME/.jupyter/

# Ensure that the default config files are available.
COPY --chown=notebook:notebook .jupyter/ /etc/default/jupyter
RUN chmod go+w -R "$HOME"

# Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
# dynamic linker run-time bindings
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig

USER notebook
RUN mkdir /tmp/spark-master /tmp/spark-worker && chmod go+w /tmp/spark-*

RUN conda init bash
WORKDIR $HOME
ENV LANG=en_US.UTF-8 \
    PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all

RUN pip install jupyterlab_github && jupyter serverextension enable --sys-prefix jupyterlab_github
CMD ["/usr/local/bin/start-notebook.sh"]
