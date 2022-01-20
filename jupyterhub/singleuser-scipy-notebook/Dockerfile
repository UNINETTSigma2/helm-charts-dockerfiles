# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# Minimal: https://github.com/jupyter/docker-stacks/tree/83ed2c63671f/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/tree/83ed2c63671f/base-notebook/Dockerfile



FROM jupyter/scipy-notebook:ee77b7831e16 as miniconda

# Note: jupyterhub currently has to be pinned to version 1.1.0 (same as server)
RUN mamba config --set channel_priority strict && \
    mamba install --quiet --yes --update-all -c conda-forge \
    'decorator==5.1.1' \
    'ipyparallel==6.2.5' \
    'jupyter-server-proxy==3.2.0' \
    'jupyter_contrib_nbextensions==0.5.1' \
    'jupyterhub==1.1.0' \
    'nbconvert==6.4.0' \
    'nbdime==3.1.1' \
    'nodejs==17.1.0' \
    'tqdm==4.62.3' \
    'yapf==0.32.0' && \
    jupyter labextension install \
    '@jupyter-widgets/jupyterlab-manager@3.0.1' \
    'jupyter-matplotlib@0.10.4' \
    'nbdime-jupyterlab@2.1.1' && \
    pip install escapism==1.0.1 jupyterlab-github==3.0.1 git+https://github.com/paalka/nbresuse.git@ca7b3422fcab2d4d78d70d0536b4efc1c36ba814 && \
    jupyter server extension enable jupyter_server_proxy --sys-prefix && \
    jupyter server extension enable --py nbresuse --sys-prefix && \
    jupyter nbextension install --py nbresuse --sys-prefix && \
    jupyter nbextension enable --py nbresuse --sys-prefix && \
    mamba clean --all -f -y

FROM jupyter/scipy-notebook:ee77b7831e16

LABEL maintainer = "Uninett As <system@uninett.no>"
USER root

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=6.3.x
RUN groupadd -g "$APP_GID" notebook && \
    useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
    usermod -G users notebook && chmod go+rwx -R "$CONDA_DIR/bin"
COPY --chown=notebook:notebook --from=miniconda $CONDA_DIR $CONDA_DIR
# hadolint ignore=DL3002
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    rm -rf /var/lib/apt/lists/*

# Refer here for versions https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/10.0/base/Dockerfile,
# note that this uses Ubuntu 16.04.
#
# https://www.tensorflow.org/install/gpu
#  and
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu-jupyter.Dockerfile
# might also be useful for CUDA packages
#
ENV PKG_CUDA_VERSION=11.4 \
    NCCL_VERSION=2.7.6 \
    PKG_CUDNN_VERSION=8.2.4.15-1+cuda11.4

RUN apt-get update && apt-get install -y --no-install-recommends \
	openssh-client \
	cuda-command-line-tools-${PKG_CUDA_VERSION/./-} \
    libcublas-${PKG_CUDA_VERSION/./-} \
    libcublas-dev-${PKG_CUDA_VERSION/./-} \
    libcufft-${PKG_CUDA_VERSION/./-} \
    libcurand-${PKG_CUDA_VERSION/./-} \
    libcurand-dev-${PKG_CUDA_VERSION/./-} \
    libcusolver-${PKG_CUDA_VERSION/./-} \
    libcusolver-dev-${PKG_CUDA_VERSION/./-} \
    libcusparse-${PKG_CUDA_VERSION/./-} \
    libcusparse-dev-${PKG_CUDA_VERSION/./-} \
    curl \
    libcudnn8 \
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
    ln -s "cuda-$PKG_CUDA_VERSION" /usr/local/cuda && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    ln -s /usr/local/cuda/include/* /usr/include/

ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all \
    TZ="Europe/Oslo"

ENV HOME=/home/notebook \
    XDG_CACHE_HOME=/home/notebook/.cache/
COPY normalize-username.py start-notebook.sh /usr/local/bin/
COPY --chown=notebook:notebook .jupyter/ /opt/.jupyter/
RUN mkdir -p /home/notebook/.ipython/profile_default/security/ && chmod go+rwx -R "$CONDA_DIR/bin" && chown notebook:notebook -R "$CONDA_DIR/bin" "$HOME" && \
    mkdir -p "$CONDA_DIR/.condatmp" && chmod go+rwx "$CONDA_DIR/.condatmp" && chown notebook:notebook "$CONDA_DIR"

# hadolint ignore=DL3002
RUN chmod go+w -R "$HOME" && chmod o+w /home && rm -r /home/notebook

USER notebook
WORKDIR $HOME
CMD ["/usr/local/bin/start-notebook.sh"]
