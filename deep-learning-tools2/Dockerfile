FROM  sigma2as/jupyter-spark:20240411-ee73753
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
    PKG_KERAS_VERSION=2.14.0 \
    PKG_TENSORFLOW_VERSION=2.14.0 \
    PKG_TENSORFLOW_PROBABILITY_VERSION=0.22.1 \
    PKG_PYTORCH_VERSION=2.2.0 \
    PKG_XGBOOST_VERSION=2.0.3 \
    PKG_CATBOOST_VERSION=1.2.2 \
    PKG_LIGHTGBM_VERSION=4.3.0\
    PKG_FASTAI_VERSION=2.7.14




RUN CC="cc -mavx2" eatmydata pip install --no-cache-dir -I -U --force-reinstall \
    hyperopt \
    pycuda \
    "keras==$PKG_KERAS_VERSION" \
    pandas-summary \
    sklearn_pandas \
    feather-format \
    plotnine \
    isoweek \
    kaggle \
    hypothesis \
    mlflow \
    "lightgbm==$PKG_LIGHTGBM_VERSION" \
    opencv-python \
    "tensorflow==$PKG_TENSORFLOW_VERSION" \
    "tensorflow-probability==$PKG_TENSORFLOW_PROBABILITY_VERSION" \
    "tensorboard-plugin-profile==$PKG_TENSORFLOW_VERSION" \
    "tensorboardx" \
    "xgboost==$PKG_XGBOOST_VERSION" \
    "catboost==$PKG_CATBOOST_VERSION" \
    sentencepiece \
    "fastai==$PKG_FASTAI_VERSION" \
    "torch==$PKG_PYTORCH_VERSION" \
    torchtext==0.17.0 \
    torchvision==0.17.0 \
    nvidia-ml-py3  && \
    jupyter lab build \
    rm -fr /home/notebook/.cache/yarn && \
    dd if=/dev/zero of=testfile bs=1M count=1024




COPY start-notebook.sh /usr/local/bin/
