FROM  sigma2as/jupyter-spark:20250205-7de094b
LABEL maintainer = "contact@sigma2.no"

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        "eatmydata"   \
        "libglfw3" && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*


RUN mkdir -p /var/log/tensorboard/ /usr/local/test-scripts && chmod o+w /var/log/tensorboard/  && \
    wget --progress=dot:giga https://storage.googleapis.com/tensorflow_docs/docs/site/en/tutorials/images/cnn.ipynb -O /usr/local/test-scripts/tf-cnn.ipynb && \
    wget --progress=dot:giga https://raw.githubusercontent.com/pytorch/examples/master/mnist/main.py -O /usr/local/test-scripts/pytorch-mnist.py

USER notebook
ENV PATH=/usr/local/mpi/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/mpi/lib:/usr/local/cuda/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all \
    PKG_KERAS_VERSION=3.8.0\
    PKG_TENSORFLOW_VERSION=2.18.0 \
    PKG_TENSORFLOW_PROBABILITY_VERSION=0.25.0 \
    PKG_PYTORCH_VERSION=2.6.0  \
    PKG_XGBOOST_VERSION=2.1.4 \
    PKG_CATBOOST_VERSION=1.2.7 \
    PKG_LIGHTGBM_VERSION=4.5.0\
    PKG_FASTAI_VERSION=2.7.18


RUN mamba config --set channel_priority strict && \
    eatmydata mamba install --quiet --update-all --yes -c conda-forge \
    pycuda \
        "keras==$PKG_KERAS_VERSION" \
        plotnine \
        kaggle \
        hypothesis \
        mlflow \
        jax \
        transformers \
        datasets  \
        tiktoken  \
        "lightgbm==$PKG_LIGHTGBM_VERSION" \
        opencv-python \
        #"tensorflow[and-cuda]==$PKG_TENSORFLOW_VERSION" \
        #"tensorflow-probability==$PKG_TENSORFLOW_PROBABILITY_VERSION" \
        "tensorboard-plugin-profile==2.19.0" \
        "xgboost==$PKG_XGBOOST_VERSION" \
        "catboost==$PKG_CATBOOST_VERSION" \
        sentencepiece \
        "fastai==$PKG_FASTAI_VERSION" \
        monai \
        albumentations \
    nvidia-ml-py \
    && mamba clean --all -f -y


RUN CC="cc -mavx2" eatmydata pip install --no-cache-dir -I -U --force-reinstall \
    "torch==$PKG_PYTORCH_VERSION" \
    torchvision==0.21.0 \
    torchaudio \
    pillow   --index-url https://download.pytorch.org/whl/cu126 && \
    jupyter lab build \
    rm -fr /home/notebook/.cache/yarn && \
    dd if=/dev/zero of=testfile bs=1M count=1024




COPY start-notebook.sh /usr/local/bin/
