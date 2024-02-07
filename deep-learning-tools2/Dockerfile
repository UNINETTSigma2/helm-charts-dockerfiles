FROM sigma2as/jupyter-spark:20240201-964601f
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
    PKG_TENSORFLOW_PROBABILITY_VERSION=0.22.0 \
    PKG_PYTORCH_VERSION=2.0.0 \
    PKG_XGBOOST_VERSION=1.7.6 \
    PKG_CATBOOST_VERSION=1.2.2 \
    PKG_LIGHTGBM_VERSION=4.0.0\
    PKG_FASTAI_VERSION=2.7.13


RUN mamba config --set channel_priority strict && \
    eatmydata mamba install --quiet --update-all --yes -c conda-forge\
    hyperopt / # ==0.2.7 \
    feather-format  / #  ==0.4.1 \
    plotnine  / #  ==0.12.3 \
    isoweek  / #  ==1.3.3 \
    kaggle  / #  ==1.5.16 \
    hypothesis  / # ==6.88.0 \
    mlflow  / #  ==2.7.1 \
    "lightgbm"  / # ==$PKG_LIGHTGBM_VERSION" \
    tensorboardx  / # ==2.6.2 \
    "xgboost"  / # ==$PKG_XGBOOST_VERSION" \
    "catboost"  / # ==$PKG_CATBOOST_VERSION" \
    sentencepiece  / #  ==0.1.99 \
    "fastai"  / #  ==$PKG_FASTAI_VERSION" \
    pycuda  / #  ==2022.2.2 \
    nvidia-ml-py  / #  ==12.535.108 \
    && mamba clean --all -f -y

RUN CC="cc -mavx2" eatmydata pip install --no-cache-dir  \
    "keras"  / # ==$PKG_KERAS_VERSION" \
    pandas-summary \
    sklearn_pandas \
    opencv-python \
    "tensorflow"   / #  ==$PKG_TENSORFLOW_VERSION" \
    "tensorflow-probability"  / #  ==$PKG_TENSORFLOW_PROBABILITY_VERSION" \
    "tensorboard-plugin-profile"  / #  ==$PKG_TENSORFLOW_VERSION" \
    && mamba clean -y -f --all

RUN CC="cc -mavx2" eatmydata pip install --no-cache-dir \
    "torch"  / # ==$PKG_PYTORCH_VERSION"  \
    torchvision  / # ==0.15.1  \
    --index-url https://download.pytorch.org/whl/cu118 \
    && mamba clean -y -f --all && \
    jupyter lab build && \
    rm -fr /home/notebook/.cache/yarn && \
    dd if=/dev/zero of=testfile bs=1M count=1024


COPY start-notebook.sh /usr/local/bin/
