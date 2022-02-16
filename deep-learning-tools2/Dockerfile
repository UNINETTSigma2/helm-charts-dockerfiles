FROM quay.io/nird-toolkit/jupyter-spark:20220216-fbbf65f
LABEL maintainer = "Uninett As <system@uninett.no>"

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        "eatmydata"   \
        "libglfw3" && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*


RUN mkdir -p /var/log/tensorboard/ /usr/local/test-scripts && chmod o+w /var/log/tensorboard/  && \
    wget https://storage.googleapis.com/tensorflow_docs/docs/site/en/tutorials/images/cnn.ipynb -O /usr/local/test-scripts/tf-cnn.ipynb && \
    wget https://raw.githubusercontent.com/pytorch/examples/master/mnist/main.py -O /usr/local/test-scripts/pytorch-mnist.py
USER notebook
ENV PATH=/usr/local/mpi/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/mpi/lib:/usr/local/cuda/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all \
    PKG_KERAS_VERSION=2.7.0 \
    PKG_TENSORFLOW_VERSION=2.7.0 \
    PKG_TENSORFLOW_PROBABILITY_VERSION=0.15.0 \
    PKG_PYTORCH_VERSION=1.10.2 \
    PKG_XGBOOST_VERSION=1.5.2 \
    PKG_CATBOOST_VERSION=1.0.4 \
    PKG_LIGHTGBM_VERSION=3.3.2 \
    PKG_FASTAI_VERSION=2.5.3

# moved  installation of 'spacy', 'mkl-service' 'pygpu'  'libjpeg-turbo=2.*'  'bcolz' 'jax'   'python-graphviz' 'libtiff' 'jupyter_contrib_nbextensions' (for fastai with notebooks) 'cudatoolkit=10.1' 'jpeg' 'pydot' to jupyter-spark Dockerfile

RUN CC="cc -mavx2" eatmydata pip install --no-cache-dir -I -U --force-reinstall \
    hyperopt \
    pycuda \
    "keras==$PKG_KERAS_VERSION" \
    keras-tqdm \
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
    "tensorflow-gpu==$PKG_TENSORFLOW_VERSION" \
    "tensorflow-probability==$PKG_TENSORFLOW_PROBABILITY_VERSION" \
    "tensorboardx" \
    "xgboost==$PKG_XGBOOST_VERSION" \
    "catboost==$PKG_CATBOOST_VERSION" \
    sentencepiece \
    "fastai==$PKG_FASTAI_VERSION" \
    torch \
    torchtext \
    torchvision \
    nvidia-ml-py3 && \
    mamba clean -y --all && \
    jupyter lab build

RUN rm -fr /home/notebook/.cache/yarn
RUN dd if=/dev/zero of=testfile bs=1M count=1024

COPY start-notebook.sh /usr/local/bin/
