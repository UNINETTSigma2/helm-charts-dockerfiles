FROM quay.io/uninett/jupyter-spark:20200417-63dfa40

LABEL maintainer Uninett As <system@uninett.no>

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
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

RUN conda update --all -y

RUN conda install --quiet --yes -c pytorch -c fastai \
    'spacy' \
    'pytorch' \
    'torchvision' \
    'fastai'

RUN conda install --quiet --yes -c conda-forge \
    'cudatoolkit=10*' \
    'mkl-service' \
    'pygpu' \
    'bcolz' \
    'jax'   \
    'python-graphviz' \
    'pydot'

RUN conda uninstall --force jpeg libtiff -y && \
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
    tensorflow-gpu==1.13.* \
    tensorflow-probability==0.6.* \
    tensorboardX==1.7 \
    opencv-python==3.4.* \
    hypothesis==3.79.* \
    mlflow==1.0.* \
    lightgbm==2.2.* \
    xgboost==0.81 \
    catboost==0.12.* \
    nvidia-ml-py3 \
    torchtext && \
    jupyter-lab build

COPY start-notebook.sh /usr/local/bin/
