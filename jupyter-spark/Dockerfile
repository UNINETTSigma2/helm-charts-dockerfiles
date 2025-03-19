# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# All Spark: https://github.com/jupyter/docker-stacks/blob/main/all-spark-notebook/Dockerfile
# PySpark: https://github.com/jupyter/docker-stacks/blob/main/pyspark-notebook/Dockerfile
# SciPy: https://github.com/jupyter/docker-stacks/blob/main/scipy-notebook/Dockerfile
# Minimal: https://github.com/jupyter/docker-stacks/blob/main/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/blob/main/base-notebook/Dockerfile
FROM quay.io/jupyter/all-spark-notebook:ae572aa64fa8 as miniconda
USER root
ENV DEBIAN_FRONTEND noninteractive \
    NODE_OPTIONS --max-old-space-size=4096 \
    NB_UID=999 \
    NB_GID=999

RUN apt-get update && apt-get install -y --no-install-recommends eatmydata apt-utils
RUN conda config --set channel_priority strict && \
    eatmydata mamba install --quiet  --yes -c conda-forge \
    'jupyterlab-github' \
    'jupyter-server-proxy' \
    # 'ipyparallel' \
    'plotly' \
    'xarray' \
    'yapf' \
    && mamba clean --all -f -y


RUN mamba create -n minimal -y && bash -c 'source activate minimal && conda install -y ipykernel && ipython kernel install --name=minimal --display-name="Python 3 (minimal conda)" && conda clean --all -f -y && conda deactivate'
USER notebook

FROM quay.io/jupyter/all-spark-notebook:ae572aa64fa8
LABEL maintainer = "contact@sigma2.no"
USER root

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=7.3.2 \
	PKG_CUDA_VERSION=12.6.3

RUN groupadd -g "$APP_GID" notebook && \
	useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
	usermod -G users notebook

# Refer here for versions https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.6.3/ubuntu2404/base/Dockerfile
# https://www.tensorflow.org/install/gpu
# and
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu-jupyter.Dockerfile
# might also be useful for CUDA packages

ENV NV_CUDA_LIB_VERSION=12.6.3-1 \
    NV_CUDNN_VERSION=9.5.1.17-1 \
    NV_CUDNN_PACKAGE_NAME="libcudnn9-cuda-12" \
    NV_CUDA_CUDART_VERSION=12.6.77-1 \
    NV_CUDA_COMPAT_PACKAGE=cuda-compat-12-6 \
    CUDA_VERSION=12.6.3 \
    NV_NVTX_VERSION=12.6.77-1\
    NV_LIBNPP_VERSION=12.3.1.54-1 \
    NV_LIBCUSPARSE_VERSION=12.5.4.2-1 \
    NV_LIBCUBLAS_PACKAGE_NAME=libcublas-12-6 \
    NV_LIBCUBLAS_VERSION=12.6.4.1-1 \
    NV_LIBNCCL_PACKAGE_NAME=libnccl2 \
    NV_LIBNCCL_PACKAGE_VERSION=2.23.4-1\
    NV_CUDA_CUDART_DEV_VERSION=12.6.77-1 \
    NV_NVML_DEV_VERSION=12.6.77-1 \
    NV_NVPROF_VERSION=12.6.80-1\
    NCCL_VERSION=2.23.4-1 \
    NV_LIBNPP_DEV_VERSION=12.3.1.54-1 \
    NV_LIBCUSPARSE_DEV_VERSION=12.5.4.2-1 \
    NV_LIBCUBLAS_DEV_VERSION=12.6.4.1-1 \
    NV_LIBCUBLAS_DEV_PACKAGE_NAME=libcublas-dev-12-6 \
    NV_LIBNCCL_DEV_PACKAGE_NAME=libnccl-dev \
    NV_LIBNCCL_DEV_PACKAGE_VERSION=2.23.4-1 \
    NV_CUDA_NSIGHT_COMPUTE_VERSION=12.6.3-1

ENV NV_CUDNN_PACKAGE="libcudnn9-cuda-12=${NV_CUDNN_VERSION}" \
    PKG_CUDNN_VERSION="$NV_CUDNN_VERSION" \
    NV_LIBNPP_PACKAGE="libnpp-12-6=${NV_LIBNPP_VERSION}"\
    NV_LIBCUBLAS_PACKAGE="${NV_LIBCUBLAS_PACKAGE_NAME}=${NV_LIBCUBLAS_VERSION}" \
    NV_NVPROF_DEV_PACKAGE="cuda-nvprof-12-6=${NV_NVPROF_VERSION}" \
    NV_LIBNCCL_PACKAGE="${NV_LIBNCCL_PACKAGE_NAME}=${NV_LIBNCCL_PACKAGE_VERSION}+cuda12.6" \
    NV_LIBNPP_DEV_PACKAGE="libnpp-dev-12-6=${NV_LIBNPP_DEV_VERSION}" \
    NV_LIBCUBLAS_DEV_PACKAGE="${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}"  \
    NV_LIBNCCL_DEV_PACKAGE="${NV_LIBNCCL_DEV_PACKAGE_NAME}=${NV_LIBNCCL_DEV_PACKAGE_VERSION}+cuda12.6" \
    NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE="cuda-nsight-compute-12-6=${NV_CUDA_NSIGHT_COMPUTE_VERSION}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/3bf863cc.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
       build-essential \
       cuda-cudart-12-6=${NV_CUDA_CUDART_VERSION} \
       "${NV_CUDA_COMPAT_PACKAGE}" \
       cuda-libraries-12-6="${NV_CUDA_LIB_VERSION}" \
       "${NV_LIBNPP_PACKAGE}" \
       cuda-nvtx-12-6="${NV_NVTX_VERSION}" \
       libcusparse-12-6="${NV_LIBCUSPARSE_VERSION}" \
       "${NV_LIBCUBLAS_PACKAGE}" \
       "${NV_LIBNCCL_PACKAGE}" \
       "${NV_CUDNN_PACKAGE}" \
        cuda-cudart-dev-12-6="${NV_CUDA_CUDART_DEV_VERSION}" \
        cuda-command-line-tools-12-6="${NV_CUDA_LIB_VERSION}" \
        cuda-minimal-build-12-6="${NV_CUDA_LIB_VERSION}" \
        cuda-libraries-dev-12-6="${NV_CUDA_LIB_VERSION}" \
        cuda-nvml-dev-12-6="${NV_NVML_DEV_VERSION}" \
        "${NV_NVPROF_DEV_PACKAGE}" \
        "${NV_LIBNPP_DEV_PACKAGE}" \
        libcusparse-dev-12-6="${NV_LIBCUSPARSE_DEV_VERSION}" \
        "${NV_LIBCUBLAS_DEV_PACKAGE}" \
        "${NV_LIBNCCL_DEV_PACKAGE}" \
        "${NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE}" \
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
       libnetcdf-dev \
       python3-netcdf4 \
       netcat-openbsd \
       sudo && \
    apt-mark hold "${NV_CUDNN_PACKAGE_NAME}" "${NV_LIBCUBLAS_PACKAGE_NAME}" "${NV_LIBNCCL_PACKAGE_NAME}" && \
    apt-mark hold "${NV_LIBCUBLAS_DEV_PACKAGE_NAME}" "${NV_LIBNCCL_DEV_PACKAGE_NAME}" && \
    apt-get install -y --only-upgrade --no-install-recommends openssl && \
    apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* \ && \
    ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime


RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    ln -s /usr/local/cuda/include/* /usr/include/

ENV TZ="Europe/Oslo" \
	NB_UID=999 \
	NB_GID=999 \
	PKG_SPARK_VERSION=${APACHE_SPARK_VERSION} \
	PKG_HADOOP_VERSION=${HADOOP_VERSION} \
	PKG_TOREE_VERSION=0.5.0-incubating \
	PKG_R_VERSION=4.4.2  \
    PKG_VS_CODE_VERSION=4.96.4 \
	HOME=/home/notebook \
	NB_USER=notebook \
    PATH=$PATH:$SPARK_HOME/bin \
    XDG_CACHE_HOME=/home/notebook/.cache/


COPY start-*.sh /usr/local/bin/
COPY mem_parser.py /usr/local/bin/
COPY --chown=notebook:notebook spark-defaults.conf /usr/local/spark/conf/
COPY --chown=notebook:notebook --from=miniconda $CONDA_DIR $CONDA_DIR
COPY --chown=notebook:notebook --from=miniconda /usr/local/share/jupyter/kernels/minimal /usr/local/share/jupyter/kernels/minimal


RUN mkdir -p "$CONDA_DIR/.condatmp" && chmod go+rwx "$CONDA_DIR/.condatmp" /usr/local/spark/conf/spark-defaults.conf

RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version="$PKG_VS_CODE_VERSION"

RUN chown notebook:notebook "$CONDA_DIR" "$CONDA_DIR/.condatmp"
COPY --chown=notebook:notebook .jupyter/ $HOME/.jupyter/

COPY --chown=notebook:notebook .jupyter/ /etc/default/jupyter
RUN chmod go+w -R "$HOME" && chmod g+w -R /usr/local/share/jupyter/kernels


RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig

# Julia dependencies
# install Julia packages in /opt/julia instead of ${HOME}
ENV JULIA_DEPOT_PATH=/opt/julia \
    JULIA_PKGDIR=/opt/julia

# Setup Julia
RUN /opt/setup-scripts/setup_julia.py



RUN fix-permissions "$CONDA_DIR"


USER notebook
RUN mkdir /tmp/spark-master /tmp/spark-worker && chmod go+w /tmp/spark-*

# Setup IJulia kernel & other packages
RUN /opt/setup-scripts/setup-julia-packages.bash

WORKDIR $HOME
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all  \
    LIBRARY_PATH=/usr/local/cuda/lib64/stubs

CMD ["/usr/local/bin/start-notebook.sh"]
