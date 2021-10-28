# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# All Spark: https://github.com/jupyter/docker-stacks/tree/ubuntu-18.04/all-spark-notebook/Dockerfile
# PySpark: https://github.com/jupyter/docker-stacks/tree/ubuntu-18.04/pyspark-notebook/Dockerfile
# SciPy: https://github.com/jupyter/docker-stacks/tree/ubuntu-18.04/scipy-notebook/Dockerfile
# Minimal: https://github.com/jupyter/docker-stacks/tree/ubuntu-18.04/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/tree/ubuntu-18.04/base-notebook/Dockerfile


FROM jupyter/all-spark-notebook:ubuntu-20.04 as miniconda
USER root
ENV DEBIAN_FRONTEND noninteractive \
    NODE_OPTIONS --max-old-space-size=4096 \
    NB_UID=999 \
    NB_GID=999

RUN apt update && apt install -y eatmydata apt-utils 
RUN conda config --set channel_priority strict && \
    eatmydata conda install --quiet --update-all --yes -c conda-forge \
    'xarray==0.19.0' \
    'ipympl==0.8.0' \
    'nodejs' \
    'rise' \
    'jupyter_contrib_nbextensions==0.5.1' \
    'cudatoolkit=11.4' \
    'tqdm==4.62.3' \
    'yapf==0.31.0' \
    'nbdime==3.1.0' \
    'nbconvert==6.2.0' \
    'decorator==5.1.0' \
    'plotly==5.3.1' \
    'ipywidgets==7.6.5' \
    'jupyter-server-proxy==3.1.0' \
    'ipykernel==6.4.1' \
    'ipyparallel==7.1.0' \
    'jupyterlab==3.1.18' \
    'jupyterlab_iframe==0.4.0' \
    'cufflinks-py==0.17.3' \
    && conda clean  --all -f -y

#spacy=3.0.1' \
#'rise' \
 #    'mkl-service=2.3.0' \
 #    'pygpu=0.7.6' \
 #    'libjpeg-turbo=2.*' \
 #    'bcolz=1.2.1' \
 #    'jax=0.2.9'   \
 #    'libtiff=4.2.0' \
 #    'python-graphviz=0.16' \
 #'pydot=1.4.1' \

RUN conda create -n minimal -y && bash -c 'source activate minimal && conda install -y ipykernel && ipython kernel install --name=minimal --display-name="Python 3 (minimal conda)" && conda clean  --all -f -y && conda deactivate'


RUN jupyter serverextension enable --py jupyterlab_iframe && \
    jupyter labextension install \
    '@jupyter-widgets/jupyterlab-manager' \
    'jupyterlab-plotly' \
    'jupyter-matplotlib' \
    'nbdime-jupyterlab' \
    '@jupyterlab/toc' \
    '@jupyterlab/server-proxy' \
    'jupyterlab_iframe@0.4.0' && \
    git clone https://github.com/paalka/nbresuse /tmp/nbresuse && pip install /tmp/nbresuse/ && \
    jupyter serverextension enable --py nbresuse --sys-prefix && \
    jupyter nbextension install --py nbresuse --sys-prefix && \
    jupyter nbextension enable --py nbresuse --sys-prefix && \
    jupyter lab build



FROM jupyter/all-spark-notebook:ubuntu-20.04
LABEL maintainer =  "Uninett As <system@uninett.no>"

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt update && apt install -y --no-install-recommends gnupg2 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    rm -rf /var/lib/apt/lists/*

ENV PKG_CUDA_VERSION=11.4 \
    NCCL_VERSION=2.7.6 \
    PKG_CUDNN_VERSION=8.2.4.15-1+cuda11.4


RUN apt update && apt install -y --no-install-recommends \
       build-essential \
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
       libfreetype6-dev \
       libhdf5-serial-dev \
       libzmq3-dev \
       pkg-config \
       software-properties-common \
       unzip \
	   python3 \
       python3-dev \
       python3-venv \
       python3-pip \
       python3-wheel \
       python3-ipykernel \
       openssh-client \
       nano \
       htop \
       less \
       net-tools \
       man-db \
       iputils-ping \
       screen \
       tmux \
       liblapack-dev \
       libopenblas-dev \
       graphviz \
       cmake \
       rsync \
       p7zip-full \
       unrar \
       vim \
       "openmpi-bin" \
       ca-certificates \
       libnetcdf-dev \
       python3-netcdf4 \
       sudo  && \
   apt install -y --only-upgrade openssl && \
	apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*  && \ 
	ln -s "cuda-$PKG_CUDA_VERSION" /usr/local/cuda

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    ln -s /usr/local/cuda/include/* /usr/include/


ENV TZ="Europe/Oslo" \
	APP_UID=999 \
	APP_GID=999 \
	NB_UID=999 \
	NB_GID=999 \
   PKG_JUPYTER_NOTEBOOK_VERSION=6.3.x \
	PKG_SPARK_VERSION=${APACHE_SPARK_VERSION} \
	PKG_HADOOP_VERSION=${HADOOP_VERSION} \
	PKG_TOREE_VERSION=0.3.0-incubating \
	PKG_R_VERSION=4.0.3 \
	PKG_VS_CODE_VERSION=2.1692-vsc1.39.2  \
	HOME=/home/notebook \
   PATH=$PATH:$SPARK_HOME/bin \
   XDG_CACHE_HOME=/home/notebook/.cache/

RUN groupadd -g "$APP_GID" notebook && \
	useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
	usermod -G users notebook

COPY start-*.sh /usr/local/bin/
COPY mem_parser.py /usr/local/bin/
COPY --chown=notebook:notebook spark-defaults.conf /usr/local/spark/conf/
COPY --chown=notebook:notebook --from=miniconda $CONDA_DIR $CONDA_DIR
COPY --chown=notebook:notebook --from=miniconda /usr/local/share/jupyter/kernels/minimal /usr/local/share/jupyter/kernels/minimal
RUN mkdir -p "$CONDA_DIR/.condatmp" && chmod go+rwx "$CONDA_DIR/.condatmp" /usr/local/spark/conf/spark-defaults.conf


RUN wget -q "https://github.com/cdr/code-server/releases/download/$PKG_VS_CODE_VERSION/code-server$PKG_VS_CODE_VERSION-linux-x86_64.tar.gz"  && \
    tar zxf "code-server$PKG_VS_CODE_VERSION-linux-x86_64.tar.gz" && \
    mv "code-server$PKG_VS_CODE_VERSION-linux-x86_64/code-server" /usr/local/bin/ && \
    rm -rf "code-server*" "$HOME/.wget-hsts" && locale-gen en_US.UTF-8



RUN chown notebook:notebook $CONDA_DIR "$CONDA_DIR/.condatmp"
COPY --chown=notebook:notebook .jupyter/ $HOME/.jupyter/

COPY --chown=notebook:notebook .jupyter/ /etc/default/jupyter
RUN chmod go+w -R "$HOME"

RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig


RUN fix-permissions $CONDA_DIR

USER notebook
RUN mkdir /tmp/spark-master /tmp/spark-worker && chmod go+w /tmp/spark-*  && \
    conda init bash
    
WORKDIR $HOME
ENV LANG=en_US.UTF-8 \
    PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all

RUN pip install jupyterlab_github && jupyter serverextension enable --sys-prefix jupyterlab_github

CMD ["/usr/local/bin/start-notebook.sh"]
