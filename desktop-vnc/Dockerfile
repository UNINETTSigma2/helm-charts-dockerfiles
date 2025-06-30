# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM ubuntu:24.04


SHELL ["/bin/bash", "-o", "pipefail", "-c"]
LABEL maintainer="contact@sigma2.no"
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl wget bzip2 ca-certificates apt-file && \
    curl -fsLO https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime

ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all \
    DEBIAN_FRONTEND=noninteractive \
    TZ="Europe/Oslo"

# Refer here for versions https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.8.0/ubuntu2204/base/Dockerfile
# https://www.tensorflow.org/install/gpu
#  and
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu-jupyter.Dockerfile
# might also be useful for CUDA packages
#
ENV PKG_CUDA_VERSION=12.6.3 \
    NV_CUDA_LIB_VERSION=12.6.3-1  \
    NV_CUDNN_VERSION=9.5.1.17-1 \
    NV_CUDNN_PACKAGE_NAME="libcudnn9-cuda-12" \
    NV_CUDA_CUDART_VERSION=12.6.77-1 \
    NV_CUDA_COMPAT_PACKAGE=cuda-compat-12-6 \
    CUDA_VERSION=12.6.3  \
    NV_NVTX_VERSION=12.6.77-1 \
    NV_LIBNPP_VERSION=12.3.1.54-1 \
    NV_LIBCUSPARSE_VERSION=12.5.4.2-1\
    NV_LIBCUBLAS_PACKAGE_NAME=libcublas-12-6 \
    NV_LIBCUBLAS_VERSION=12.6.4.1-1 \
    NV_LIBNCCL_PACKAGE_NAME=libnccl2 \
    NV_LIBNCCL_PACKAGE_VERSION=2.23.4-1 \
    NV_CUDA_CUDART_DEV_VERSION=12.6.77-1 \
    NV_NVML_DEV_VERSION=12.6.77-1 \
    NV_NVPROF_VERSION=12.6.80-1 \
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

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

## Repo for ncl-ncarg
# RUN echo "deb http://archive.ubuntu.com/ubuntu/ noble-proposed universe" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales ca-certificates xauth ssh \
    unzip htop gedit\
    x11-xserver-utils adwaita-icon-theme-full \
    chromium-browser chromium-browser-l10n autoconf libtool pkg-config automake \
    chromium-codecs-ffmpeg vim emacs net-tools libxrender1 mesa-utils  \
    locales  python3-numpy ttf-wqy-zenhei libxext-dev libx11-dev x11proto-gl-dev \
    supervisor xfce4 xfce4-terminal xterm dbus-x11 glmark2 \
    libnss-wrapper gettext csh zsh nano gv openssh-client tcsh rsync less cdo nco ncview \
    # ncl-ncarg \
    # Problems getting dependencies. Cant find libcarg0t64 or libsphere0d
    cuda-cudart-12-6="${NV_CUDA_CUDART_VERSION}" \
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
    openmpi-bin && \
    apt-mark hold "${NV_CUDNN_PACKAGE_NAME}" "${NV_LIBCUBLAS_PACKAGE_NAME}" "${NV_LIBNCCL_PACKAGE_NAME}" && \
    apt-mark hold "${NV_LIBCUBLAS_DEV_PACKAGE_NAME}" "${NV_LIBNCCL_DEV_PACKAGE_NAME}" && \
    apt-file search libnss_wrapper.so && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

#RUN wget https://github.com/NVIDIA/libglvnd/archive/v1.2.0.tar.gz && \
#    tar xvf v1.2.0.tar.gz && cd libglvnd-1.2.0 && ./autogen.sh && ./configure && make && cd ..

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
RUN locale-gen en_US.UTF-8 && \
    echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    ln -s /usr/local/cuda/include/* /usr/include/

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=7.0.5  \
    HOME=/home/vncuser \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false \
    XFCE_PANEL_MIGRATE_DEFAULT=true

WORKDIR $HOME
COPY ./src/common/install/ $INST_SCRIPTS/
COPY ./src/ubuntu/install/ $INST_SCRIPTS/
COPY ./src/common/xfce/ $HOME/

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh &&   \
    $INST_SCRIPTS/no_vnc.sh &&   \
    $INST_SCRIPTS/libnss_wrapper.sh

# configure startup
COPY ./src/common/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME /headless
ENV HOME=""

# websockify expects python command
RUN ln -s /usr/bin/python3 /usr/bin/python

USER vncuser

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
