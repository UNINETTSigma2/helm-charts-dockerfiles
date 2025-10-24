# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# Minimal: https://github.com/jupyter/docker-stacks/tree/d400e383cc1d/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/tree/d400e383cc1d/base-notebook/Dockerfile
FROM quay.io/jupyter/datascience-notebook:47423b6d549e as miniconda
USER root
RUN conda config --set channel_priority strict && \
    mamba install --quiet --yes  -c conda-forge \
    'escapism==1.0.1' \
    'jupyterlab-github==4.0.0' \
    'jupyter-server-proxy==4.4.0' \
    'yapf==0.43.0' && \
    mamba clean --all -f -y \
RUN pip uninstall 'jupyter-pluto-proxy'

RUN mamba create -n minimal -y && bash -c 'source activate minimal && conda install -y ipykernel && ipython kernel install --name=minimal --display-name="Python 3 (minimal conda)" && conda clean --all -f -y && conda deactivate'
USER notebook

FROM quay.io/jupyter/datascience-notebook:47423b6d549e

LABEL maintainer="contact@sigma2.no"
USER root

#RUN conda config --set channel_priority strict && \
#    mamba uninstall 'jupyter-pluto-proxy'
RUN pip uninstall 'jupyter-pluto-proxy'

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=7.4.7 \
	PKG_CUDA_VERSION=12.8.1

RUN groupadd -g "$APP_GID" notebook && \
    useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
    usermod -G users notebook && chmod go+rwx -R "$CONDA_DIR/bin"
COPY --chown=notebook:notebook --from=miniconda $CONDA_DIR $CONDA_DIR
COPY --chown=notebook:notebook --from=miniconda /usr/local/share/jupyter/kernels/minimal /usr/local/share/jupyter/kernels/minimal


# Refer here for versions https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.7.1/ubuntu2204/base/Dockerfile
# https://www.tensorflow.org/install/gpu
# and
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu-jupyter.Dockerfile
# might also be useful for CUDA packages

ENV NV_CUDA_LIB_VERSION=12.8.1-1 \
    NV_CUDNN_VERSION=9.8.0.87-1 \
    NV_CUDNN_PACKAGE_NAME="libcudnn9-cuda-12" \
    NV_CUDA_CUDART_VERSION=12.8.90-1 \
    NV_CUDA_COMPAT_PACKAGE=cuda-compat-12-8 \
    CUDA_VERSION=12.8.1 \
    NV_NVTX_VERSION=12.8.90-1\
    NV_LIBNPP_VERSION=12.3.3.100-1 \
    NV_LIBCUSPARSE_VERSION=12.5.8.93-1 \
    NV_LIBCUBLAS_PACKAGE_NAME=libcublas-12-8 \
    NV_LIBCUBLAS_VERSION=12.8.4.1-1 \
    NV_LIBNCCL_PACKAGE_NAME=libnccl2 \
    NV_LIBNCCL_PACKAGE_VERSION=2.26.2-1\
    NV_CUDA_CUDART_DEV_VERSION=12.8.90-1 \
    NV_NVML_DEV_VERSION=12.8.90-1 \
    NV_NVPROF_VERSION=12.8.90-1\
    NCCL_VERSION=2.26.2-1 \
    NV_LIBNPP_DEV_VERSION=12.3.3.100-1 \
    NV_LIBCUSPARSE_DEV_VERSION=12.5.8.93-1 \
    NV_LIBCUBLAS_DEV_VERSION=12.8.4.1-1 \
    NV_LIBCUBLAS_DEV_PACKAGE_NAME=libcublas-dev-12-8 \
    NV_LIBNCCL_DEV_PACKAGE_NAME=libnccl-dev \
    NV_LIBNCCL_DEV_PACKAGE_VERSION=2.26.2-1 \
    NV_CUDA_NSIGHT_COMPUTE_VERSION=12.8.1-1 \
    CUDA_TOOLKIT_VERSION=12.8.1-1 \
    NVIDIA_GDS_VERSION=12.8.1-1 \
    CUDA_DRIVER_VERSION=570.133.20-0ubuntu1 \
    LIBGLU1_MESA_DEV_VERSION=9.0.2-1.1build1 \
    FREEGLUT3_DEV_VERSION=3.4.0-1build1 \
    MESA_COMMON_DEV_VERSION=24.0.5-1ubuntu1 \
    LIBFREEIMAGE_DEV_VERSION=3.18.0+ds2-10build4

ENV NV_CUDNN_PACKAGE="libcudnn9-cuda-12=${NV_CUDNN_VERSION}" \
    PKG_CUDNN_VERSION="$NV_CUDNN_VERSION" \
    NV_LIBNPP_PACKAGE="libnpp-12-8=${NV_LIBNPP_VERSION}"\
    NV_LIBCUBLAS_PACKAGE="${NV_LIBCUBLAS_PACKAGE_NAME}=${NV_LIBCUBLAS_VERSION}" \
    NV_NVPROF_DEV_PACKAGE="cuda-nvprof-12-8=${NV_NVPROF_VERSION}" \
    NV_LIBNCCL_PACKAGE="${NV_LIBNCCL_PACKAGE_NAME}=${NV_LIBNCCL_PACKAGE_VERSION}+cuda12.8" \
    NV_LIBNPP_DEV_PACKAGE="libnpp-dev-12-8=${NV_LIBNPP_DEV_VERSION}" \
    NV_LIBCUBLAS_DEV_PACKAGE="${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}"  \
    NV_LIBNCCL_DEV_PACKAGE="${NV_LIBNCCL_DEV_PACKAGE_NAME}=${NV_LIBNCCL_DEV_PACKAGE_VERSION}+cuda12.8" \
    NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE="cuda-nsight-compute-12-8=${NV_CUDA_NSIGHT_COMPUTE_VERSION}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/3bf863cc.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-toolkit=12.8.1-1 \
        nvidia-gds=12.8.1-1 \
        cuda-drivers-570="${CUDA_DRIVER_VERSION}" \
        libglu1-mesa-dev="${LIBGLU1_MESA_DEV_VERSION}" \
        freeglut3-dev="${FREEGLUT3_DEV_VERSION}" \
        mesa-common-dev="${MESA_COMMON_DEV_VERSION}" \
        libfreeimage-dev="${LIBFREEIMAGE_DEV_VERSION}" \
    build-essential \
           cuda-cudart-12-8=${NV_CUDA_CUDART_VERSION} \
           "${NV_CUDA_COMPAT_PACKAGE}" \
           cuda-libraries-12-8="${NV_CUDA_LIB_VERSION}" \
           "${NV_LIBNPP_PACKAGE}" \
           cuda-nvtx-12-8="${NV_NVTX_VERSION}" \
           libcusparse-12-8="${NV_LIBCUSPARSE_VERSION}" \
           "${NV_LIBCUBLAS_PACKAGE}" \
           "${NV_LIBNCCL_PACKAGE}" \
           "${NV_CUDNN_PACKAGE}" \
            cuda-cudart-dev-12-8="${NV_CUDA_CUDART_DEV_VERSION}" \
            cuda-command-line-tools-12-8="${NV_CUDA_LIB_VERSION}" \
            cuda-minimal-build-12-8="${NV_CUDA_LIB_VERSION}" \
            cuda-libraries-dev-12-8="${NV_CUDA_LIB_VERSION}" \
            cuda-nvml-dev-12-8="${NV_NVML_DEV_VERSION}" \
            "${NV_NVPROF_DEV_PACKAGE}" \
            "${NV_LIBNPP_DEV_PACKAGE}" \
            libcusparse-dev-12-8="${NV_LIBCUSPARSE_DEV_VERSION}" \
            "${NV_LIBCUBLAS_DEV_PACKAGE}" \
            "${NV_LIBNCCL_DEV_PACKAGE}" \
            "${NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE}" \
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
    apt-mark hold "${NV_LIBCUBLAS_DEV_PACKAGE_NAME}" "${NV_LIBNCCL_DEV_PACKAGE_NAME}" && \
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
