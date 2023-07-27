# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# Minimal: https://github.com/jupyter/docker-stacks/tree/bfe5f20914d0/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/tree/bfe5f20914d0/base-notebook/Dockerfile
FROM jupyter/scipy-notebook:bfe5f20914d0 as miniconda
RUN mamba config --set channel_priority strict && \
    mamba install --quiet --yes --update-all -c conda-forge \
    'ipyparallel==6.3.0' && \
    mamba clean --all -f -y


FROM jupyter/scipy-notebook:bfe5f20914d0
LABEL maintainer = "contact@sigma2.no"
USER root

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=7.0.0 \
	PKG_CUDA_VERSION=11.7.1

RUN groupadd -g "$APP_GID" notebook && \
    useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
    usermod -G users notebook && chmod go+rwx -R "$CONDA_DIR/bin"
COPY --chown=notebook:notebook --from=miniconda $CONDA_DIR $CONDA_DIR

# Refer here for versions https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.7.1/ubuntu2204/base/Dockerfile
# https://www.tensorflow.org/install/gpu
# and
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu-jupyter.Dockerfile
# might also be useful for CUDA packages

ENV NV_CUDA_LIB_VERSION=11.7.1-1  \
    NV_CUDNN_VERSION=8.5.0.96 \
    NV_CUDNN_PACKAGE_NAME="libcudnn8" \
    NV_CUDA_CUDART_VERSION=11.7.99-1 \
    NV_CUDA_COMPAT_PACKAGE=cuda-compat-11-7 \
    CUDA_VERSION=11.7.1  \
    NV_NVTX_VERSION=11.7.91-1 \
    NV_LIBNPP_VERSION=11.7.4.75-1 \
    NV_LIBCUSPARSE_VERSION=11.7.4.91-1 \
    NV_LIBCUBLAS_PACKAGE_NAME=libcublas-11-7 \
    NV_LIBCUBLAS_VERSION=11.10.3.66-1 \
    NV_LIBNCCL_PACKAGE_NAME=libnccl2 \
    NV_LIBNCCL_PACKAGE_VERSION=2.13.4-1 \
    NCCL_VERSION=2.13.4-1 

ENV NV_CUDNN_PACKAGE="libcudnn8=$NV_CUDNN_VERSION-1+cuda11.7" \
    PKG_CUDNN_VERSION="$NV_CUDNN_VERSION-1+cuda11.7" \
    NV_LIBNPP_PACKAGE="libnpp-11-7=${NV_LIBNPP_VERSION}"\
    NV_LIBCUBLAS_PACKAGE="${NV_LIBCUBLAS_PACKAGE_NAME}=${NV_LIBCUBLAS_VERSION}" \
    NV_LIBNCCL_PACKAGE="${NV_LIBNCCL_PACKAGE_NAME}=${NV_LIBNCCL_PACKAGE_VERSION}+cuda11.7"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsLO https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-11-7=${NV_CUDA_CUDART_VERSION} \
    ${NV_CUDA_COMPAT_PACKAGE} \
    cuda-libraries-11-7=${NV_CUDA_LIB_VERSION} \
    ${NV_LIBNPP_PACKAGE} \
    cuda-nvtx-11-7=${NV_NVTX_VERSION} \
    libcusparse-11-7=${NV_LIBCUSPARSE_VERSION} \
    ${NV_LIBCUBLAS_PACKAGE} \
    ${NV_LIBNCCL_PACKAGE} \
    ${NV_CUDNN_PACKAGE} \
	openssh-client \
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
    sudo \
    inkscape \
    "openmpi-bin" && \
    apt-mark hold ${NV_CUDNN_PACKAGE_NAME} ${NV_LIBCUBLAS_PACKAGE_NAME} ${NV_LIBNCCL_PACKAGE_NAME} && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all \
    TZ="Europe/Oslo" \
    HOME=/home/notebook \
    XDG_CACHE_HOME=/home/notebook/.cache/


COPY normalize-username.py start-notebook.sh /usr/local/bin/
COPY --chown=notebook:notebook .jupyter/ /opt/.jupyter/
RUN mkdir -p /home/notebook/.ipython/profile_default/security/ && chmod go+rwx -R "$CONDA_DIR/bin" && chown notebook:notebook -R "$CONDA_DIR/bin" "$HOME" && \
    mkdir -p "$CONDA_DIR/.condatmp" && chmod go+rwx "$CONDA_DIR/.condatmp" && chown notebook:notebook "$CONDA_DIR" && \
    chmod go+w -R "$HOME" && chmod o+w /home && rm -r /home/notebook

USER notebook
WORKDIR $HOME
CMD ["/usr/local/bin/start-notebook.sh"]
