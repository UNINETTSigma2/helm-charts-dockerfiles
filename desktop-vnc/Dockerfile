# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM ubuntu:20.04


SHELL ["/bin/bash", "-o", "pipefail", "-c"]
LABEL maintainer Uninett As <system@uninett.no>

RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 ca-certificates curl && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime

ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all \
    DEBIAN_FRONTEND=noninteractive \
    TZ="Europe/Oslo"

# Refer here for versions https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/9.0/base/Dockerfile,
# note that this uses Ubuntu 16.04.
#
# https://www.tensorflow.org/install/gpu
#  and
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu-jupyter.Dockerfile
# might also be useful for CUDA packages
#
ENV PKG_CUDA_VERSION=11.2 \
    NCCL_VERSION=2.7.6 \
    PKG_CUDNN_VERSION=8.2.4.15-1+cuda11.4

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT


RUN apt-get update && apt-get install -y --no-install-recommends \
    locales firefox ca-certificates xauth ssh \
    unzip htop gedit\
    x11-xserver-utils adwaita-icon-theme-full \
    chromium-browser chromium-browser-l10n autoconf libtool pkg-config automake \
    chromium-codecs-ffmpeg vim emacs wget net-tools libxrender1 mesa-utils  \
    locales bzip2 python-numpy ttf-wqy-zenhei libxext-dev libx11-dev x11proto-gl-dev \
    supervisor xfce4 xfce4-terminal xterm dbus-x11 glmark2 \
    libnss-wrapper gettext csh zsh nano gv openssh-client tcsh rsync less ncl-ncarg cdo nco ncview \
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
    libcudnn8 \
    openmpi-bin && \
    ln -s "cuda-$PKG_CUDA_VERSION" /usr/local/cuda && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/NVIDIA/libglvnd/archive/v1.1.1.tar.gz && \
    tar xvf v1.1.1.tar.gz && cd libglvnd-1.1.1 && ./autogen.sh && ./configure && make && cd ..

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
RUN locale-gen en_US.UTF-8

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    ln -s /usr/local/cuda/include/* /usr/include/

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=6.3.x

ENV HOME=/home/vncuser \
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
ADD ./src/common/install/ $INST_SCRIPTS/
ADD ./src/ubuntu/install/ $INST_SCRIPTS/
ADD ./src/common/xfce/ $HOME/

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh &&   \
    $INST_SCRIPTS/no_vnc.sh &&   \
    $INST_SCRIPTS/chrome.sh &&   \
    $INST_SCRIPTS/libnss_wrapper.sh

# configure startup
ADD ./src/common/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME /headless
ENV HOME=""

USER vncuser

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
