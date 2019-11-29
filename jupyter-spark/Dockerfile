# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# All Spark: https://github.com/jupyter/docker-stacks/tree/d4cbf2f80a2a/all-spark-notebook/Dockerfile
# PySpark: https://github.com/jupyter/docker-stacks/tree/d4cbf2f80a2a/pyspark-notebook/Dockerfile
# SciPy: https://github.com/jupyter/docker-stacks/tree/d4cbf2f80a2a/scipy-notebook/Dockerfile
# Minimal: https://github.com/jupyter/docker-stacks/tree/d4cbf2f80a2a/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/tree/d4cbf2f80a2a/base-notebook/Dockerfile

#FROM jupyter/all-spark-notebook:a330137134e7
FROM jupyter/all-spark-notebook:abdb27a6dfbb as miniconda
USER root
ENV DEBIAN_FRONTEND noninteractive \
    NB_UID=999 \
    NB_GID=999

RUN conda install --quiet --yes -c conda-forge \
    'jupyter_contrib_nbextensions=0.5*' \
    'tqdm=4.31*' \
    'yapf=0.26*' \
    'nbdime=1.0*' \
    'nbconvert=5.5*' \
    'plotly=3.6*' && \
    conda install --quiet --yes -c damianavila82 'rise=5.4*' && \
    conda clean -tipsy

# Add a minimal conda environment in order to make it easier to add custom pages.
RUN conda create -n minimal -y && bash -c 'source activate minimal && conda install -y ipykernel && ipython kernel install --name=minimal --display-name="Python 3 (minimal conda)" && conda deactivate'

#hadolint ignore=DL3013
RUN pip install ipyparallel==6.2.* jupyterlab-github==0.6.* cufflinks==0.14.* \
    jupyter-server-proxy==1.2.0 jupyterlab_iframe==0.0.11 && \
    jupyter serverextension enable --py jupyter_server_proxy jupyterlab_iframe && \
    jupyter labextension install \
    '@jupyterlab/github@0.10.0' \
    'nbdime-jupyterlab@0.6.0' \
    '@jupyterlab/plotly-extension@0.18.2' \
    '@jupyterlab/toc@0.6.0' \
    'jupyterlab-server-proxy@1.0.0' \
    'jupyterlab_iframe' && \
    git clone https://github.com/paalka/nbresuse /tmp/nbresuse && pip install /tmp/nbresuse/ && \
    jupyter serverextension enable --py nbresuse --sys-prefix && \
    jupyter nbextension install --py nbresuse --sys-prefix && \
    jupyter nbextension enable --py nbresuse --sys-prefix && \
    jupyter lab build

RUN fix-permissions $CONDA_DIR

FROM jupyter/all-spark-notebook:abdb27a6dfbb
LABEL maintainer Uninett As <system@uninett.no>

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2=2.2.4-1ubuntu1 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    rm -rf /var/lib/apt/lists/*

# Refer here for versions https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/10.0/base/Dockerfile,
# note that this uses Ubuntu 16.04.
#
# https://www.tensorflow.org/install/gpu
#  and
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu-jupyter.Dockerfile
# might also be useful for CUDA packages
#
ENV PKG_CUDA_VERSION=10.0.130 \
    NCCL_VERSION=2.4.2 \
    PKG_CUDNN_VERSION=7.5.0.56

RUN apt-get update && apt-get install -y --no-install-recommends \
        "cuda-cudart-10-0=$PKG_CUDA_VERSION-1" \
        "cuda-cublas-10-0=$PKG_CUDA_VERSION-1" \
        "cuda-cublas-dev-10-0=$PKG_CUDA_VERSION-1" \
        "cuda-cudart-dev-10-0=$PKG_CUDA_VERSION-1" \
        "libcudnn7=$PKG_CUDNN_VERSION-1+cuda10.0" \
        "libcudnn7-dev=$PKG_CUDNN_VERSION-1+cuda10.0" \
        "cuda-libraries-10-0=$PKG_CUDA_VERSION-1" \
        "cuda-libraries-dev-10-0=$PKG_CUDA_VERSION-1" \
        "cuda-nvml-dev-10-0=$PKG_CUDA_VERSION-1" \
        "cuda-minimal-build-10-0=$PKG_CUDA_VERSION-1" \
        "cuda-command-line-tools-10-0=$PKG_CUDA_VERSION-1" \
        "libnccl2=$NCCL_VERSION-1+cuda10.0" \
        "libnccl-dev=$NCCL_VERSION-1+cuda10.0" \
        "cuda-compat-10-0=410.48-1" \
        "openmpi-bin=2.1.1-8" && \
    ln -s cuda-10.0 /usr/local/cuda

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
    cmake \
    rsync=3.1.2-2.1ubuntu1 \
    p7zip-full=16.02+dfsg-6 \
    unrar=1:5.5.8-1 \
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
	PKG_R_VERSION=3.5.1 \
	PKG_VS_CODE_VERSION=2.1692-vsc1.39.2

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
RUN mkdir -p "$CONDA_DIR/.condatmp" && chmod go+rwx "$CONDA_DIR/.condatmp" /usr/local/spark/conf/spark-defaults.conf

RUN wget -q "https://github.com/cdr/code-server/releases/download/$PKG_VS_CODE_VERSION/code-server$PKG_VS_CODE_VERSION-linux-x86_64.tar.gz"  && \
    tar zxf "code-server$PKG_VS_CODE_VERSION-linux-x86_64.tar.gz" && \
    mv "code-server$PKG_VS_CODE_VERSION-linux-x86_64/code-server" /usr/local/bin/ && \
    rm -rf "code-server$PKG_VS_CODE_VERSION-linux-x86_64/*" "$HOME/.wget-hsts" && locale-gen en_US.UTF-8

RUN chown notebook:notebook $CONDA_DIR "$CONDA_DIR/.condatmp"
COPY --chown=notebook:notebook .jupyter/ $HOME/.jupyter/

# Ensure that the default config files are available.
COPY --chown=notebook:notebook .jupyter/ /etc/default/jupyter
RUN chmod go+w -R "$HOME"

USER notebook
RUN mkdir /tmp/spark-master /tmp/spark-worker && chmod go+w /tmp/spark-*

RUN conda init bash
WORKDIR $HOME
ENV LANG=en_US.UTF-8 \
    PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all

CMD ["/usr/local/bin/start-notebook.sh"]
