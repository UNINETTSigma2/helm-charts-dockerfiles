FROM quay.io/uninett/jupyter-spark:20190527-1bc373e

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
        "openmpi-bin=2.1.1-8" \
        "libglfw3" && \
    ln -s cuda-10.0 /usr/local/cuda && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    ln -s /usr/local/cuda/include/* /usr/include/

RUN mkdir -p /var/log/tensorboard/ && chmod o+w /var/log/tensorboard/
USER notebook
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all \
    PKG_KERAS_VERSION=2.2.4 \
    PKG_TENSORFLOW_VERSION=1.13.1 \
    PKG_TENSORFLOW_PROBABILITY_VERSION=0.4.0 \
    PKG_PYTORCH_VERSION=1.1.0 \
    PKG_XGBOOST_VERSION=0.81 \
    PKG_CATBOOST_VERSION=0.12.2 \
    PKG_LIGHTGBM_VERSION=2.2.3 \
    PKG_FASTAI_VERSION=1.0.52

ENV PATH /usr/local/mpi/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/mpi/lib:$LD_LIBRARY_PATH

RUN conda install --quiet --yes -c conda-forge \
    'mkl-service=1.1*' \
    'pygpu=0.7*' \
    'theano=1.0*' \
    'bcolz=1.2.*' \
    'python-graphviz=0.8*' \
    'spacy=2.0.*' \
    'pydot=1.2.*' && \
    conda clean -tipsy && \
    conda install --quiet --yes -c pytorch -c fastai \
    'fastai=1.0*' \
    'pytorch=1.1*' \
    'torchvision=0.3*' \
    'fastprogress=0.1*' && \
    conda uninstall --force jpeg libtiff -y && \
    conda install -c conda-forge 'libjpeg-turbo=2.*' && \
    conda install -y jpeg libtiff && \
    conda clean -tipsy

RUN CC="cc -mavx2" pip install --no-cache-dir -I -U --force-reinstall \
    hyperopt==0.1.* \
    pycuda==2018.1.1 \
    keras==2.2.* \
    keras-tqdm==2.0.* \
    kaggle==1.5.* \
    pandas-summary==0.0.6 \
    sklearn_pandas==1.8.* \
    feather-format==0.4.* \
    plotnine==0.3.0 \
    isoweek==1.3.3 \
    torchtext==0.3.1 \
    tensorflow-gpu==1.13.* \
    tensorflow-probability-gpu==0.4.* \
    tensorboardX==1.7 \
    opencv-python==3.4.* \
    hypothesis==3.79.* \
    mlflow==1.0.* \
    lightgbm==2.2.* \
    xgboost==0.81 \
    catboost==0.12.*

RUN pip uninstall -y numpy && pip install numpy==1.16.*

COPY start-notebook.sh /usr/local/bin/
