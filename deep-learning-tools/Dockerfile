FROM jupyter/base-notebook

USER root
# Install cuDNN library
RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
    NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 && \
    apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
    apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +5 > cudasign.pub && \
    echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub && \
    echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV CUDNN_VERSION 7.0.5.15
ENV CUDA_VERSION 8.0.61
ENV CUDA_PKG_VERSION 8-0=$CUDA_VERSION-1

RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-core-$CUDA_PKG_VERSION \
        cuda-misc-headers-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        cuda-nvrtc-dev-$CUDA_PKG_VERSION \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-nvgraph-dev-$CUDA_PKG_VERSION \
        cuda-cusolver-dev-$CUDA_PKG_VERSION \
        cuda-cublas-dev-8-0=8.0.61.2-1 \
        cuda-cufft-dev-$CUDA_PKG_VERSION \
        cuda-curand-dev-$CUDA_PKG_VERSION \
        cuda-cusparse-dev-$CUDA_PKG_VERSION \
        cuda-npp-dev-$CUDA_PKG_VERSION \
        cuda-cudart-dev-$CUDA_PKG_VERSION \
        cuda-driver-dev-$CUDA_PKG_VERSION \
        nano vim g++ liblapack-dev libopenblas-dev \
        git-core unzip less curl python-dev graphviz \
        screen tmux \
        libcudnn7=$CUDNN_VERSION-1+cuda8.0 \
        libcudnn7-dev=$CUDNN_VERSION-1+cuda8.0 && \
    rm -rf /var/lib/apt/lists/*

RUN echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda-8.0/lib64" >> /etc/ld.so.conf.d/nvidia.conf
RUN ln -s /usr/local/cuda-8.0/include/* /usr/include/
ENV PATH /usr/local/nvidia/bin/:/usr/local/cuda-8.0/bin/:${PATH}

RUN mkdir -p /data /data/notebooks
ENV NOTEBOOKS_CONFIG_DIR /etc/jupyter
COPY jupyter_notebook_config.py $NOTEBOOKS_CONFIG_DIR/
RUN conda install theano=1.0.1 keras==1.2.2 networkx==1.11 pandas \
    seaborn pygpu=0.7.5 mkl-service pytorch=0.3.0 torchvision=0.2.0 ipywidgets=7.1.1 \
    tensorflow-gpu=1.4.1 tqdm=4.19.5
RUN pip install hyperopt==0.1 pycuda
RUN conda clean -tipsy && apt autoclean
RUN echo "[global]\ndevice=cuda\nfloatX=float32\n[gpuarray]\npreallocate=1\n[blas]\nldflags = -lopenblas\n" > $HOME/.theanorc
RUN mkdir $HOME/.keras
RUN echo "{\n\"image_data_format\": \"channels_last\",\n\"epsilon\": 1e-07,\"floatx\": \"float32\",\"backend\": \"theano\"\n}" > $HOME/.keras/keras.json
COPY start.sh /usr/local/bin/
RUN chown -R jovyan /data/
WORKDIR /data/notebooks
