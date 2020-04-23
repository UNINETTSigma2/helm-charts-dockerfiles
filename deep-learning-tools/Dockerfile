FROM quay.io/uninett/jupyter-spark:20200420-1131dd2

LABEL maintainer Uninett As <system@uninett.no>

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        "eatmydata"           \
        "openmpi-bin=2.1.1-8" \
        "libglfw3" && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/tensorboard/ && chmod o+w /var/log/tensorboard/
USER notebook
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all \
    PKG_KERAS_VERSION=2.3.1 \
    PKG_TENSORFLOW_VERSION=1.15 \
    PKG_TENSORFLOW_PROBABILITY_VERSION=0.9.0 \
    PKG_PYTORCH_VERSION=1.4 \
    PKG_XGBOOST_VERSION=1.0.2 \
    PKG_CATBOOST_VERSION=0.22 \
    PKG_LIGHTGBM_VERSION=2.3.1 \
    PKG_FASTAI_VERSION=1.0.60

ENV PATH /usr/local/mpi/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/mpi/lib:$LD_LIBRARY_PATH

RUN conda config --set channel_priority strict && \
    eatmydata conda install --quiet --yes -c pytorch -c fastai \
    'spacy=2.1' \
    "pytorch=$PKG_PYTORCH_VERSION" \
    'cudatoolkit=10.1' \
    'torchvision' \
    "fastai=$PKG_FASTAI_VERSION"

RUN conda uninstall --force jpeg libtiff -y 
RUN conda config --set channel_priority false && \
    eatmydata conda install --quiet --yes -c conda-forge \
    'mkl-service' \
    'pygpu' \
    'libjpeg-turbo=2' \
    'bcolz' \
    'jax'   \
    'python-graphviz' \
    'jpeg' \
    'libtiff' \
    'jupyter_contrib_nbextensions' # This is needed when using fastai with notebooks \
    'pydot' && \
    conda clean -tipsy

RUN CC="cc -mavx2" eatmydata pip install --no-cache-dir -I -U --force-reinstall \
    hyperopt==0.2.* \
    pycuda==2019.1.2 \
    "keras==$PKG_KERAS_VERSION" \
    keras-tqdm==2.0.* \
    pandas-summary==0.0.7 \
    sklearn_pandas==1.8.* \
    feather-format==0.4.* \
    plotnine==0.6.0 \
    isoweek==1.3.3 \
    torchtext==0.5.0 \
    kaggle==1.5.* \
    opencv-python==4.2.* \
    hypothesis==5.10.* \
    mlflow==1.7.* \
    "lightgbm==$PKG_LIGHTGBM_VERSION" \
    "tensorflow==$PKG_TENSORFLOW_VERSION" \
    "tensorflow-probability==$PKG_TENSORFLOW_PROBABILITY_VERSION" \
    "tensorboardx==2.0" \
    "xgboost==$PKG_XGBOOST_VERSION" \
    "catboost==$PKG_CATBOOST_VERSION" \
    sentencepiece \
    nvidia-ml-py3 && \
    jupyter lab build

COPY start-notebook.sh /usr/local/bin/
