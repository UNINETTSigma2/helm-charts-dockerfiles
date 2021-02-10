# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# All Spark: https://github.com/jupyter/docker-stacks/tree/ubuntu-18.04/all-spark-notebook/Dockerfile
# PySpark: https://github.com/jupyter/docker-stacks/tree/ubuntu-18.04/pyspark-notebook/Dockerfile
# SciPy: https://github.com/jupyter/docker-stacks/tree/ubuntu-18.04/scipy-notebook/Dockerfile
# Minimal: https://github.com/jupyter/docker-stacks/tree/ubuntu-18.04/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/tree/ubuntu-18.04/base-notebook/Dockerfile


FROM jupyter/all-spark-notebook:ubuntu-18.04 as miniconda
USER root
ENV DEBIAN_FRONTEND noninteractive \
    NB_UID=999 \
    NB_GID=999

RUN apt update && apt install -y eatmydata apt-utils 
RUN conda config --set channel_priority strict

RUN eatmydata conda install --quiet --update-all --yes -c conda-forge \
    'spacy' \
    'mkl-service' \
    'pygpu' \
    'libjpeg-turbo=2.*' \
    'bcolz' \
    'jax'   \
    'libtiff' \
    'python-graphviz' \
    'jupyter_contrib_nbextensions' \
    'pydot' \
    'cudatoolkit=10.1' \
    'tqdm=4.56.0' \
    'yapf=0.30.0' \
    'nbdime=2.1.0' \
    'nbconvert=6.0.7' \
    'plotly=4.14.3' \
    'rise=5.7.1' \
    'ipywidgets=7.6.3' \
    'jupyter-server-proxy=1.5.3' \
    'ipykernel=5.4.3' \
    'ipyparallel=6.3.0' \
    'jupyterlab=2.2.9' \
    'jupyterlab_iframe=0.3.0' \
    'cufflinks-py=0.17.3' \
    && conda clean  --all -f -y

RUN conda create -n minimal -y && bash -c 'source activate minimal && conda install -y ipykernel && ipython kernel install --name=minimal --display-name="Python 3 (minimal conda)" && conda clean  --all -f -y && conda deactivate'

ENV NODE_OPTIONS --max-old-space-size=4096
RUN jupyter serverextension enable --py jupyter_server_proxy jupyterlab_iframe && \
    jupyter labextension install \
    '@jupyter-widgets/jupyterlab-manager' \
    'plotlywidget@4.14.3' \
    'jupyterlab-plotly@4.14.3' \
    '@jupyterlab/github' \
    'nbdime-jupyterlab' \
    '@jupyterlab/toc' \
    '@jupyterlab/server-proxy' \
    'jupyterlab_iframe@0.2.3' && \
    git clone https://github.com/paalka/nbresuse /tmp/nbresuse && pip install /tmp/nbresuse/ && \
    jupyter serverextension enable --py nbresuse --sys-prefix && \
    jupyter nbextension install --py nbresuse --sys-prefix && \
    jupyter nbextension enable --py nbresuse --sys-prefix && \
    jupyter lab build

RUN fix-permissions $CONDA_DIR

FROM jupyter/all-spark-notebook:ubuntu-18.04
LABEL maintainer Uninett As <system@uninett.no>

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    rm -rf /var/lib/apt/lists/*

ENV PKG_CUDA_VERSION=10.0 \
    NCCL_VERSION=2.7.6 \
    PKG_CUDNN_VERSION=7.6.2.24-1    

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-${PKG_CUDA_VERSION/./-} \
        cuda-cublas-${PKG_CUDA_VERSION/./-} \
        cuda-cublas-dev-${PKG_CUDA_VERSION/./-} \
        cuda-cufft-${PKG_CUDA_VERSION/./-} \
        cuda-curand-${PKG_CUDA_VERSION/./-} \
        cuda-curand-dev-${PKG_CUDA_VERSION/./-} \
        cuda-cusolver-${PKG_CUDA_VERSION/./-} \
        cuda-cusolver-dev-${PKG_CUDA_VERSION/./-} \
        cuda-cusparse-${PKG_CUDA_VERSION/./-} \
        cuda-cusparse-dev-${PKG_CUDA_VERSION/./-} \
        curl \
        libcudnn7=${PKG_CUDNN_VERSION}+cuda${PKG_CUDA_VERSION} \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        software-properties-common \
        unzip \
        "openmpi-bin" && ln -s "cuda-$PKG_CUDA_VERSION" /usr/local/cuda

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
    openssh-client=1:7.6p1-4ubuntu0.3 \
    nano=2.9.3-2 \
    htop=2.1.0-3 \
    less=487-0.1 \
    net-tools=1.60+git20161116.90da8a0-1ubuntu1 \
    man-db=2.8.3-2ubuntu0.1 \
    iputils-ping=3:20161105-1ubuntu3 \
    screen=4.6.2-1ubuntu1 \
    tmux=2.6-3ubuntu0.2 \
    liblapack-dev=3.7.1-4ubuntu1 \
    libopenblas-dev=0.2.20+ds-4 \
    graphviz=2.40.1-2 \
    cmake=3.10.2-1ubuntu2.18.04.1 \
    rsync=3.1.2-2.1ubuntu1.1 \
    p7zip-full=16.02+dfsg-6 \
    unrar=1:5.5.8-1 \
    vim=2:8.0.1453-1ubuntu1.4 && \
    apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ENV TZ="Europe/Oslo"

ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=6.2.x \
	PKG_SPARK_VERSION=${APACHE_SPARK_VERSION} \
	PKG_HADOOP_VERSION=${HADOOP_VERSION} \
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

COPY --chown=notebook:notebook .jupyter/ /etc/default/jupyter
RUN chmod go+w -R "$HOME"

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
