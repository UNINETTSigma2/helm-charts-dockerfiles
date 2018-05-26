FROM quay.io/uninett/jupyter-spark:20180525-3a3c4dd

LABEL maintainer Uninett As <system@uninett.no>

# hadolint ignore=DL3002
USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https=1.2.26 gnupg-curl=1.4.20-1ubuntu3.1 && \
    rm -rf /var/lib/apt/lists/* && \
    NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
    NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
    apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +5 > cudasign.pub && \
    echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV PKG_CUDA_VERSION=9.2.88 \
    NCCL_VERSION=2.2.12 \
    PKG_CUDNN_VERSION=7.1.4.18


RUN apt-get update && apt-get install -y --no-install-recommends \
        "cuda-cudart-9-2=$PKG_CUDA_VERSION-1" \
        "libcudnn7=$PKG_CUDNN_VERSION-1+cuda9.2" \
        "libcudnn7-dev=$PKG_CUDNN_VERSION-1+cuda9.2" \
        "cuda-libraries-9-2=$PKG_CUDA_VERSION-1" \
        "cuda-libraries-dev-9-2=$PKG_CUDA_VERSION-1" \
        "cuda-nvml-dev-9-2=$PKG_CUDA_VERSION-1" \
        "cuda-minimal-build-9-2=$PKG_CUDA_VERSION-1" \
        "cuda-command-line-tools-9-2=$PKG_CUDA_VERSION-1" \
        "libnccl-dev=$NCCL_VERSION-1+cuda9.2" \
        "openmpi-bin=1.10.2-8ubuntu1" && \
    ln -s cuda-9.2 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    ln -s /usr/local/cuda/include/* /usr/include/

USER notebook

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES all \
    NVIDIA_DRIVER_CAPABILITIES compute,utility \
    PKG_THEANO_VERSION=1.0.2 \
    PKG_KERAS_VERSION=2.1.5 \
    PKG_TENSORFLOW_VERSION=1.8.0 \
    PKG_PYTORCH_VERSION=0.4.0 \
    PKG_MXNET_VERSION=1.2.0 \
    PKG_ONNX_VERSION=1.2.1 \
    PKG_CNTK_VERSION=2.5.1 \
    PKG_CAFFE2_VERSION=0.8.dev


RUN conda install --quiet --yes -c caffe2 \
    'caffe2-cuda9.0-cudnn7=0.8.dev' && \
    conda clean -tipsy && \
    conda install --quiet --yes -c conda-forge \
    'mkl-service=1.1*' \
    'pygpu=0.7*' \
    'theano=1.0*' \
    'keras==2.1*' \
    'pytorch=0.4*' \
    'torchvision=0.2*' \
    'visdom=0.1*' && \
    conda clean -tipsy && \
    conda install --quiet --yes -c pytorch \
    'magma-cuda91=2.3*' \
    'faiss-gpu=1.2*' && \
    conda remove --force --yes pillow && \
    conda clean -tipsy

RUN CC="cc -mavx2" pip install --no-cache-dir -I -U --force-reinstall --user \
    hyperopt==0.1 \
    pycuda==2017.1.1 \
    pillow-simd==5.1.1.post0 \
    cntk-gpu==2.5.1 \
    onnx==1.2.1 \
    tensorflow-gpu==1.8.0 \
    jupyter-tensorboard==0.1.6 \
    mxnet-cu92mkl==1.2.0b20180525 \
    onnx-mxnet==0.4.2 \
    mxboard==0.1.0 \
    hypothesis==3.57.0
