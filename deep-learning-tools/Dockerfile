FROM quay.io/uninett/jupyter-spark:20181114-71fc41e

LABEL maintainer Uninett As <system@uninett.no>

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2=2.2.4-1ubuntu1 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1710/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1710/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    rm -rf /var/lib/apt/lists/*

# Refer here for versions https://gitlab.com/nvidia/cuda/blob/ubuntu18.04/9.2/base/Dockerfile
ENV PKG_CUDA_VERSION=9.2.148 \
    NCCL_VERSION=2.3.7 \
    PKG_CUDNN_VERSION=7.4.1.5

RUN apt-get update && apt-get install -y --no-install-recommends \
        "cuda-cupti-9-2=$PKG_CUDA_VERSION-1" \
        "cuda-cudart-9-2=$PKG_CUDA_VERSION-1" \
        "cuda-cudart-dev-9-2=$PKG_CUDA_VERSION-1" \
        "libcudnn7=$PKG_CUDNN_VERSION-1+cuda9.2" \
        "libcudnn7-dev=$PKG_CUDNN_VERSION-1+cuda9.2" \
        "cuda-libraries-9-2=$PKG_CUDA_VERSION-1" \
        "cuda-libraries-dev-9-2=$PKG_CUDA_VERSION-1" \
        "cuda-nvml-dev-9-2=$PKG_CUDA_VERSION-1" \
        "cuda-minimal-build-9-2=$PKG_CUDA_VERSION-1" \
        "cuda-command-line-tools-9-2=$PKG_CUDA_VERSION-1" \
        "libnccl2=$NCCL_VERSION-1+cuda9.2" \
        "libnccl-dev=$NCCL_VERSION-1+cuda9.2" \
        "openmpi-bin=2.1.1-8" && \
    ln -s cuda-9.2 /usr/local/cuda && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    ln -s /usr/local/cuda/include/* /usr/include/

#hadolint ignore=DL3003
# RUN OPENMPI_VERSION=1.10.3 && \
#     curl -fsSL https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-${OPENMPI_VERSION}.tar.gz | tar -xzf - && \
#     cd openmpi-${OPENMPI_VERSION} && \
#     ./configure --prefix=/usr/local/mpi >/dev/null && \
#     make -j"$(nproc)" install >/dev/null && \
#     cd "$OLDPWD" && \
#     rm -rf ./openmpi-${OPENMPI_VERSION}

USER notebook
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all \
    PKG_THEANO_VERSION=1.0.2 \
    PKG_KERAS_VERSION=2.2.4 \
    PKG_TENSORFLOW_VERSION=1.12.0 \
    PKG_TENSORFLOW_PROBABILITY_VERSION=0.4.0 \
    PKG_PYTORCH_VERSION=0.4.1 \
    PKG_MXNET_VERSION=1.3.0 \
    PKG_ONNX_VERSION=1.3.0 \
    PKG_CNTK_VERSION=2.6.0 \
    PKG_CAFFE2_VERSION=0.8.dev

ENV PATH /usr/local/mpi/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/mpi/lib:$LD_LIBRARY_PATH

RUN conda install --quiet --yes -c caffe2 \
    'caffe2-cuda9.0-cudnn7=0.8.dev' && \
    conda clean -tipsy && \
    conda install --quiet --yes -c conda-forge \
    'mkl-service=1.1*' \
    'pygpu=0.7*' \
    'imagehash=4.0*' \
    'theano=1.0*' \
    'pytorch=0.4*' \
    'torchvision=0.2*' \
    'bcolz=1.2.*' \
    'python-graphviz=0.8*' \
    'libjpeg-turbo=2.0*' \
    'spacy=2.0.*' \
    'pydot=1.2.*' && \
    conda clean -tipsy && \
    conda install --quiet --yes -c pytorch \
    'magma-cuda91=2.3*' \
    'faiss-gpu=1.2*' && \
    # conda install --quiet --yes -c fastai \
    # 'fastprogress' && \
    conda remove --force --yes pillow && \
    conda clean -tipsy

RUN CC="cc -mavx2" pip install --no-cache-dir -I -U --force-reinstall \
    hyperopt==0.1 \
    pycuda==2018.1.1 \
    cntk-gpu==2.6.* \
    onnx==1.3.* \
    keras==2.2.* \
    keras-tqdm==2.0.* \
    kaggle==1.5.* \
    pandas-summary==0.0.5 \
    sklearn_pandas==1.6.* \
    feather-format==0.4.* \
    plotnine==0.3.0 \
    isoweek==1.3.3 \
    torchtext==0.3.1 \
    mxnet-cu92==1.3.* \
    keras-mxnet==2.2.* \
    onnx-mxnet==0.4.* \
    mxboard==0.1.* \
    tensorflow-gpu==1.12.* \
    tensorflow-probability-gpu==0.4.* \
    tensorboardX==1.4 \
    opencv-python==3.4.* \
    pillow-simd==5.3.0.post0 \
    hypothesis==3.79.*

COPY start-notebook.sh /usr/local/bin/
