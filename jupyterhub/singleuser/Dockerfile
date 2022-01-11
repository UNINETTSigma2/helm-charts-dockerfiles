# Link to all the dockerfiles which this image is based upon. This provides info about various packages
# already present in the image. When updating the upstream image tag, remember to update the links as well.

# Minimal: https://github.com/jupyter/docker-stacks/tree/83ed2c63671f/minimal-notebook/Dockerfile
# Base: https://github.com/jupyter/docker-stacks/tree/83ed2c63671f/base-notebook/Dockerfile



FROM jupyter/datascience-notebook:061a02b21fea as miniconda
# RUN conda update conda python && pip install -U 'pip==18.*'
RUN conda config --set channel_priority strict && \
    conda install --quiet --yes --update-all -c conda-forge \
    'aiohttp==3.7.4.post0' \
    'alembic==1.7.4' \
    'altair==4.1.0' \
    'anyio==3.3.4' \
    'appdirs==1.4.4' \
    'argon2-cffi==21.1.0' \
    'async-timeout==3.0.1' \
    'async_generator==1.10' \
    'attrs==21.2.0' \
    'babel==2.9.1' \
    'backcall==0.2.0' \
    'backports==1.0' \
    'backports.functools_lru_cache==1.6.4' \
    'beautifulsoup4==4.10.0' \
    'binutils_impl_linux-64==2.36.1' \
    'binutils_linux-64==2.36' \
    'blas==2.112' \
    'blas-devel==3.9.0' \
    'bleach==4.1.0' \
    'blinker==1.4' \
    'blosc==1.21.0' \
    'bokeh==2.4.1' \
    'bottleneck==1.3.2' \
    'brotli==1.0.9' \
    'brotli-bin==1.0.9' \
    'brunsli==0.1' \
    'bwidget==1.9.14' \
    'bzip2==1.0.8' \
    'c-ares==1.18.1' \
    'c-blosc2==2.0.4' \
    'ca-certificates==2021.10.8' \
    'cached-property==1.5.2' \
    'cached_property==1.5.2' \
    'cairo==1.16.0' \
    'certifi==2021.10.8' \
    'certipy==0.1.3' \
    'cfitsio==4.0.0' \
    'chardet==4.0.0' \
    'charls==2.2.0' \
    'charset-normalizer==2.0.0' \
    'click==8.0.3' \
    'colorama==0.4.4' \
    'cloudpickle==2.0.0' \
    'conda-package-handling==1.7.3' \
    'conda==4.10.3' \
    'cryptography==35.0.0' \
    'configurable-http-proxy==1.3.0' \
    'cycler==0.11.0' \
    'curl==7.79.1' \
    'dask-core==2021.11.0' \
    'cython==0.29.24' \
    'defusedxml==0.7.1' \
    'decorator==5.1.0' \
    'entrypoints==0.3' \
    'dill==0.3.4' \
    'font-ttf-inconsolata==3.000' \
    'font-ttf-dejavu-sans-mono==2.37' \
    'font-ttf-ubuntu==0.83' \
    'font-ttf-source-code-pro==2.038' \
    'fonts-conda-ecosystem==1' \
    'fontconfig==2.13.1' \
    'freetype==2.10.4' \
    'fonts-conda-forge==1' \
    'gcc_impl_linux-64==9.4.0' \
    'fribidi==1.0.10' \
    'gettext==0.19.8.1' \
    'gcc_linux-64==9.4.0' \
    'gfortran_linux-64==9.4.0' \
    'gfortran_impl_linux-64==9.4.0' \
    'gitdb==4.0.9' \
    'giflib==5.2.1' \
    'gmp==6.2.1' \
    'gitpython==3.1.24' \
    'greenlet==1.1.2' \
    'graphite2==1.3.13' \
    'gxx_impl_linux-64==9.4.0' \
    'gsl==2.7' \
    'h5py==3.4.0' \
    'gxx_linux-64==9.4.0' \
    'harfbuzz==3.1.0' \
    'hdf5==1.12.1' \
    'heapdict==1.0.1' \
    'icu==68.2' \
    'idna==3.1' \
    'imagecodecs==2021.8.26' \
    'imageio==2.9.0' \
    'importlib-metadata==4.8.1' \
    'importlib_resources==5.4.0' \
    'ipykernel==6.4.2' \
    'ipympl==0.8.2' \
    'ipyparallel==7.1.0' \
    'ipython_genutils==0.2.0' \
    'ipywidgets==7.6.5' \
    'jbig==2.1' \
    'jedi==0.18.0' \
    'jinja2==3.0.2' \
    'joblib==1.1.0' \
    'jpeg==9d' \
    'json5==0.9.5' \
    'jupyter-server-mathjax==0.2.3' \
    'jupyter-server-proxy==1.4.0' \
    'jupyter_client==7.0.6' \
    'jupyter_contrib_core==0.3.3' \
    'jupyter_contrib_nbextensions==0.5.1' \
    'jupyter_core==4.9.1' \
    'jupyter_highlight_selected_word==0.2.0' \
    'jupyter_latex_envs==1.4.6' \
    'jupyter_nbextensions_configurator==0.4.1' \
    'jupyter_server==1.11.2' \
    'jupyter_telemetry==0.1.0' \
    'jupyterhub-base==1.1.0' \
    'jupyterlab_pygments==0.1.2' \
    'jupyterlab_server==1.2.0' \
    'jupyterlab_widgets==1.0.2' \
    'jxrlib==1.1' \
    'kernel-headers_linux-64==2.6.32' \
    'kiwisolver==1.3.2' \
    'krb5==1.19.2' \
    'lcms2==2.12' \
    'ld_impl_linux-64==2.36.1' \
    'lerc==3.0' \
    'libaec==1.0.6' \
    'libarchive==3.5.2' \
    'libblas==3.9.0' \
    'libbrotlicommon==1.0.9' \
    'libbrotlidec==1.0.9' \
    'libbrotlienc==1.0.9' \
    'libcblas==3.9.0' \
    'libcurl==7.79.1' \
    'libdeflate==1.8' \
    'libedit==3.1.20191231' \
    'libev==4.33' \
    'libffi==3.4.2' \
    'libgcc-devel_linux-64==9.4.0' \
    'libgcc-ng==11.2.0' \
    'libgfortran-ng==11.2.0' \
    'libgfortran5==11.2.0' \
    'libgit2==1.3.0' \
    'libglib==2.70.0' \
    'libgomp==11.2.0' \
    'libiconv==1.16' \
    'liblapack==3.9.0' \
    'liblapacke==3.9.0' \
    'libllvm11==11.1.0' \
    'libnghttp2==1.43.0' \
    'libopenblas==0.3.18' \
    'libpng==1.6.37' \
    'libprotobuf==3.19.1' \
    'libsanitizer==9.4.0' \
    'libsodium==1.0.18' \
    'libsolv==0.7.19' \
    'libssh2==1.10.0' \
    'libstdcxx-devel_linux-64==9.4.0' \
    'libstdcxx-ng==11.2.0' \
    'libtiff==4.3.0' \
    'libuuid==2.32.1' \
    'libuv==1.42.0' \
    'libwebp-base==1.2.1' \
    'libxcb==1.13' \
    'libxml2==2.9.12' \
    'libxslt==1.1.33' \
    'libzlib==1.2.11' \
    'libzopfli==1.0.3' \
    'llvm-openmp==12.0.1' \
    'llvmlite==0.37.0' \
    'locket==0.2.0' \
    'lxml==4.6.4' \
    'lz4-c==1.9.3' \
    'lzo==2.10' \
    'make==4.3' \
    'mako==1.1.5' \
    'mamba==0.17.0' \
    'markupsafe==2.0.1' \
    'matplotlib-base==3.4.3' \
    'matplotlib-inline==0.1.3' \
    'mistune==0.8.4' \
    'mock==4.0.3' \
    'mpc==1.2.1' \
    'mpfr==4.1.0' \
    'mpmath==1.2.1' \
    'msgpack-python==1.0.2' \
    'multidict==5.2.0' \
    'nbclassic==0.3.3' \
    'nbclient==0.5.4' \
    'nbconvert==6.2.0' \
    'nbdime==3.1.0' \
    'nbformat==5.1.3' \
    'ncurses==6.2' \
    'nest-asyncio==1.5.1' \
    'networkx==2.6.3' \
    'nodejs==16.12.0' \
    'notebook==6.4.5' \
    'numba==0.54.1' \
    'numexpr==2.7.3' \
    'numpy==1.20.3' \
    'oauthlib==3.1.1' \
    'olefile==0.46' \
    'openblas==0.3.18' \
    'openjpeg==2.4.0' \
    'openssl==1.1.1l' \
    'packaging==21.0' \
    'pamela==1.0.0' \
    'pandas==1.3.4' \
    'pandoc==2.16.1' \
    'pandocfilters==1.5.0' \
    'pango==1.48.10' \
    'parso==0.8.2' \
    'partd==1.2.0' \
    'patsy==0.5.2' \
    'pcre==8.45' \
    'pcre2==10.37' \
    'pexpect==4.8.0' \
    'pickleshare==0.7.5' \
    'pillow==8.3.2' \
    'pip==21.3.1' \
    'pixman==0.40.0' \
    'pooch==1.5.2' \
    'prometheus_client==0.12.0' \
    'protobuf==3.19.1' \
    'psutil==5.8.0' \
    'pthread-stubs==0.4' \
    'ptyprocess==0.7.0' \
    'pycosat==0.6.3' \
    'pycurl==7.44.1' \
    'pygments==2.10.0' \
    'pyjwt==2.3.0' \
    'pyopenssl==21.0.0' \
    'pysocks==1.7.1' \
    'pytables==3.6.1' \
    'python==3.9.7' \
    'python-dateutil==2.8.2' \
    'python-json-logger==2.0.1' \
    'python-tzdata==2021.5' \
    'python_abi==3.9' \
    'pytz==2021.3' \
    'pytz-deprecation-shim==0.1.0.post0' \
    'pywavelets==1.1.1' \
    'pyzmq==22.3.0' \
    'r-askpass==1.1' \
    'r-assertthat==0.2.1' \
    'r-backports==1.3.0' \
    'r-base==4.1.1' \
    'r-base64enc==0.1_3' \
    'r-bit==4.0.4' \
    'r-bit64==4.0.5' \
    'r-bitops==1.0_7' \
    'r-blob==1.2.2' \
    'r-brew==1.0_6' \
    'r-brio==1.1.2' \
    'r-broom==0.7.10' \
    'r-bslib==0.3.1' \
    'r-cachem==1.0.6' \
    'r-callr==3.7.0' \
    'r-caret==6.0_90' \
    'r-cellranger==1.1.0' \
    'r-class==7.3_19' \
    'r-cli==3.1.0' \
    'r-clipr==0.7.1' \
    'r-codetools==0.2_18' \
    'r-colorspace==2.0_2' \
    'r-commonmark==1.7' \
    'r-conflicted==1.0.4' \
    'r-covr==3.5.1' \
    'r-cpp11==0.4.1' \
    'r-crayon==1.4.2' \
    'r-credentials==1.3.1' \
    'r-crosstalk==1.2.0' \
    'r-curl==4.3.2' \
    'r-data.table==1.14.2' \
    'r-dbi==1.1.1' \
    'r-dbplyr==2.1.1' \
    'r-desc==1.4.0' \
    'r-devtools==2.4.2' \
    'r-dials==0.0.10' \
    'r-dicedesign==1.9' \
    'r-diffobj==0.3.5' \
    'r-digest==0.6.28' \
    'r-dplyr==1.0.7' \
    'r-dt==0.19' \
    'r-dtplyr==1.1.0' \
    'r-e1071==1.7_9' \
    'r-ellipsis==0.3.2' \
    'r-evaluate==0.14' \
    'r-fansi==0.4.2' \
    'r-farver==2.1.0' \
    'r-fastmap==1.1.0' \
    'r-fontawesome==0.2.2' \
    'r-forcats==0.5.1' \
    'r-foreach==1.5.1' \
    'r-forecast==8.15' \
    'r-fracdiff==1.5_1' \
    'r-fs==1.5.0' \
    'r-furrr==0.2.3' \
    'r-future==1.23.0' \
    'r-future.apply==1.8.1' \
    'r-gargle==1.2.0' \
    'r-generics==0.1.1' \
    'r-gert==1.4.2' \
    'r-ggplot2==3.3.5' \
    'r-gh==1.3.0' \
    'r-git2r==0.28.0' \
    'r-gitcreds==0.1.1' \
    'r-globals==0.14.0' \
    'r-glue==1.5.0' \
    'r-googledrive==2.0.0' \
    'r-googlesheets4==1.0.0' \
    'r-gower==0.2.2' \
    'r-gpfit==1.0_8' \
    'r-gtable==0.3.0' \
    'r-hardhat==0.1.6' \
    'r-haven==2.4.3' \
    'r-hexbin==1.28.2' \
    'r-highr==0.9' \
    'r-hms==1.1.1' \
    'r-htmltools==0.5.2' \
    'r-htmlwidgets==1.5.4' \
    'r-httpuv==1.6.3' \
    'r-httr==1.4.2' \
    'r-ids==1.0.1' \
    'r-infer==1.0.0' \
    'r-ini==0.3.1' \
    'r-ipred==0.9_12' \
    'r-irdisplay==1.0' \
    'r-irkernel==1.2' \
    'r-isoband==0.2.5' \
    'r-iterators==1.0.13' \
    'r-jquerylib==0.1.4' \
    'r-jsonlite==1.7.2' \
    'r-kernsmooth==2.23_20' \
    'r-knitr==1.35' \
    'r-labeling==0.4.2' \
    'r-later==1.2.0' \
    'r-lattice==0.20_45' \
    'r-lava==1.6.10' \
    'r-lazyeval==0.2.2' \
    'r-lhs==1.1.3' \
    'r-lifecycle==1.0.1' \
    'r-listenv==0.8.0' \
    'r-lmtest==0.9_39' \
    'r-lubridate==1.8.0' \
    'r-magrittr==2.0.1' \
    'r-markdown==1.1' \
    'r-mass==7.3_54' \
    'r-matrix==1.3_4' \
    'r-memoise==2.0.0' \
    'r-mgcv==1.8_38' \
    'r-mime==0.12' \
    'r-modeldata==0.1.1' \
    'r-modelmetrics==1.2.2.2' \
    'r-modelr==0.1.8' \
    'r-munsell==0.5.0' \
    'r-nlme==3.1_153' \
    'r-nnet==7.3_16' \
    'r-numderiv==2016.8_1.1' \
    'r-nycflights13==1.0.2' \
    'r-openssl==1.4.5' \
    'r-parallelly==1.28.1' \
    'r-parsnip==0.1.7' \
    'r-patchwork==1.1.1' \
    'r-pbdzmq==0.3_6' \
    'r-pillar==1.6.4' \
    'r-pkgbuild==1.2.0' \
    'r-pkgconfig==2.0.3' \
    'r-pkgload==1.2.3' \
    'r-plogr==0.2.0' \
    'r-plyr==1.8.6' \
    'r-praise==1.0.0' \
    'r-prettyunits==1.1.1' \
    'r-proc==1.18.0' \
    'r-processx==3.5.2' \
    'r-prodlim==2019.11.13' \
    'r-progress==1.2.2' \
    'r-progressr==0.9.0' \
    'r-promises==1.2.0.1' \
    'r-proxy==0.4_26' \
    'r-ps==1.6.0' \
    'r-purrr==0.3.4' \
    'r-quadprog==1.5_8' \
    'r-quantmod==0.4.18' \
    'r-r6==2.5.1' \
    'r-randomforest==4.6_14' \
    'r-rappdirs==0.3.3' \
    'r-rcmdcheck==1.4.0' \
    'r-rcolorbrewer==1.1_2' \
    'r-rcpp==1.0.7' \
    'r-rcpparmadillo==0.10.7.3.0' \
    'r-rcurl==1.98_1.5' \
    'r-readr==2.0.2' \
    'r-readxl==1.3.1' \
    'r-recipes==0.1.17' \
    'r-rematch==1.0.1' \
    'r-rematch2==2.1.2' \
    'r-remotes==2.4.1' \
    'r-repr==1.1.3' \
    'r-reprex==2.0.1' \
    'r-reshape2==1.4.4' \
    'r-rex==1.2.0' \
    'r-rlang==0.4.12' \
    'r-rmarkdown==2.11' \
    'r-rodbc==1.3_19' \
    'r-roxygen2==7.1.2' \
    'r-rpart==4.1_15' \
    'r-rprojroot==2.0.2' \
    'r-rsample==0.1.0' \
    'r-rsqlite==2.2.8' \
    'r-rstudioapi==0.13' \
    'r-rversions==2.1.1' \
    'r-rvest==1.0.2' \
    'r-sass==0.4.0' \
    'r-scales==1.1.1' \
    'r-selectr==0.4_2' \
    'r-sessioninfo==1.2.1' \
    'r-shiny==1.7.1' \
    'r-slider==0.2.2' \
    'r-sourcetools==0.1.7' \
    'r-squarem==2021.1' \
    'r-stringi==1.7.5' \
    'r-stringr==1.4.0' \
    'r-survival==3.2_13' \
    'r-sys==3.4' \
    'r-testthat==3.1.0' \
    'r-tibble==3.1.6' \
    'r-tidymodels==0.1.4' \
    'r-tidyr==1.1.4' \
    'r-tidyselect==1.1.1' \
    'r-tidyverse==1.3.1' \
    'r-timedate==3043.102' \
    'r-tinytex==0.35' \
    'r-tseries==0.10_48' \
    'r-ttr==0.24.2' \
    'r-tune==0.1.6' \
    'r-tzdb==0.2.0' \
    'r-urca==1.3_0' \
    'r-usethis==2.1.3' \
    'r-utf8==1.2.2' \
    'r-uuid==1.0_3' \
    'r-vctrs==0.3.8' \
    'r-viridislite==0.4.0' \
    'r-vroom==1.5.5' \
    'r-waldo==0.3.1' \
    'r-warp==0.2.0' \
    'r-whisker==0.4' \
    'r-withr==2.4.2' \
    'r-workflows==0.2.4' \
    'r-workflowsets==0.1.0' \
    'r-xfun==0.28' \
    'r-xml2==1.3.2' \
    'r-xopen==1.0.0' \
    'r-xtable==1.8_4' \
    'r-xts==0.12.1' \
    'r-yaml==2.2.1' \
    'r-yardstick==0.0.8' \
    'r-zip==2.2.0' \
    'r-zoo==1.8_9' \
    'readline==8.1' \
    'reproc==14.2.3' \
    'reproc-cpp==14.2.3' \
    'requests==2.26.0' \
    'requests-unixsocket==0.2.0' \
    'rpy2==3.4.5' \
    'ruamel.yaml==0.17.17' \
    'ruamel.yaml.clib==0.2.2' \
    'ruamel_yaml==0.15.80' \
    'scikit-image==0.18.3' \
    'scikit-learn==1.0.1' \
    'scipy==1.7.1' \
    'seaborn==0.11.2' \
    'seaborn-base==0.11.2' \
    'sed==4.8' \
    'send2trash==1.8.0' \
    'simpervisor==0.4' \
    'simplegeneric==0.8.1' \
    'six==1.16.0' \
    'smmap==3.0.5' \
    'snappy==1.1.8' \
    'sniffio==1.2.0' \
    'sortedcontainers==2.4.0' \
    'sqlalchemy==1.4.26' \
    'sqlite==3.36.0' \
    'statsmodels==0.13.0' \
    'sympy==1.9' \
    'sysroot_linux-64==2.12' \
    'tblib==1.7.0' \
    'terminado==0.12.1' \
    'testpath==0.5.0' \
    'threadpoolctl==3.0.0' \
    'tk==8.6.11' \
    'tktable==2.10' \
    'tornado==6.1' \
    'tqdm==4.62.3' \
    'traitlets==5.1.1' \
    'typing-extensions==3.10.0.2' \
    'typing_extensions==3.10.0.2' \
    'tzdata==2021e' \
    'tzlocal==4.1' \
    'unixodbc==2.3.9' \
    'urllib3==1.26.7' \
    'wcwidth==0.2.5' \
    'webencodings==0.5.1' \
    'websocket-client==0.57.0' \
    'wheel==0.37.0' \
    'widgetsnbextension==3.5.2' \
    'xlrd==2.0.1' \
    'xorg-kbproto==1.0.7' \
    'xorg-libice==1.0.10' \
    'xorg-libsm==1.2.3' \
    'xorg-libx11==1.7.2' \
    'xorg-libxau==1.0.9' \
    'xorg-libxdmcp==1.1.3' \
    'xorg-libxext==1.3.4' \
    'xorg-libxrender==0.9.10' \
    'xorg-libxt==1.2.1' \
    'xorg-renderproto==0.11.1' \
    'xorg-xextproto==7.3.0' \
    'xorg-xproto==7.0.31' \
    'xz==5.2.5' \
    'yaml==0.2.5' \
    'yapf==0.31.0' \
    'yarl==1.7.2' \
    'zeromq==4.3.4' \
    'zfp==0.5.5' \
    'zict==2.0.0' \
    'zipp==3.6.0' \
    'zlib==1.2.11' \
    'zstd==1.5.0' && \
    jupyter labextension install \
    '@jupyter-widgets/jupyterlab-manager' \
    'nbdime-jupyterlab' \
    'jupyter-matplotlib' \
    '@jupyterlab/toc' \
    '@jupyterlab/hub-extension' && \
    pip install  jupyterlab-github escapism && \
    git clone https://github.com/paalka/nbresuse /tmp/nbresuse && pip install /tmp/nbresuse/ && \
    jupyter serverextension enable --py nbresuse --sys-prefix && \
    jupyter serverextension enable jupyter_server_proxy --sys-prefix && \
    jupyter nbextension install --py nbresuse --sys-prefix && \
    jupyter nbextension enable --py nbresuse --sys-prefix && \
    conda clean  --all -f -y


FROM jupyter/datascience-notebook:061a02b21fea

LABEL maintainer = "Uninett As <system@uninett.no>"
USER root

# Setup ENV for Appstore to be picked up
ENV APP_UID=999 \
	APP_GID=999 \
	PKG_JUPYTER_NOTEBOOK_VERSION=6.3.x
RUN groupadd -g "$APP_GID" notebook && \
    useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
    usermod -G users notebook && chmod go+rwx -R "$CONDA_DIR/bin"
COPY --chown=notebook:notebook --from=miniconda $CONDA_DIR $CONDA_DIR
# hadolint ignore=DL3002
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    rm -rf /var/lib/apt/lists/*

# Refer here for versions https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/10.0/base/Dockerfile,
# note that this uses Ubuntu 16.04.
#
# https://www.tensorflow.org/install/gpu
#  and
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu-jupyter.Dockerfile
# might also be useful for CUDA packages
#
ENV PKG_CUDA_VERSION=11.4 \
    NCCL_VERSION=2.7.6 \
    PKG_CUDNN_VERSION=8.2.4.15-1+cuda11.4

RUN apt-get update && apt-get install -y --no-install-recommends \
	openssh-client \
	cuda-command-line-tools-${PKG_CUDA_VERSION/./-} \
    libcublas-${PKG_CUDA_VERSION/./-} \
    libcublas-dev-${PKG_CUDA_VERSION/./-} \
    libcufft-${PKG_CUDA_VERSION/./-} \
    libcurand-${PKG_CUDA_VERSION/./-} \
    libcurand-dev-${PKG_CUDA_VERSION/./-} \
    libcusolver-${PKG_CUDA_VERSION/./-} \
    libcusolver-dev-${PKG_CUDA_VERSION/./-} \
    libcusparse-${PKG_CUDA_VERSION/./-} \
    libcusparse-dev-${PKG_CUDA_VERSION/./-} \
    curl \
    libcudnn8 \
	less \
	net-tools \
	man-db \
	iputils-ping \
	screen \
	tmux \
	graphviz \
	cmake \
	rsync \
	p7zip-full \
	tzdata \
	vim \
	unrar \
	ca-certificates \
    sudo \
    inkscape \
    "openmpi-bin" && \
    ln -s "cuda-$PKG_CUDA_VERSION" /usr/local/cuda && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
    ln -s /usr/local/cuda/include/* /usr/include/


ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH} \
    NVIDIA_VISIBLE_DEVICES="" \
    NVIDIA_DRIVER_CAPABILITIES=all \
    TZ="Europe/Oslo"

ENV HOME=/home/notebook \
    XDG_CACHE_HOME=/home/notebook/.cache/
COPY normalize-username.py start-notebook.sh /usr/local/bin/
COPY --chown=notebook:notebook .jupyter/ /opt/.jupyter/
RUN mkdir -p /home/notebook/.ipython/profile_default/security/ && chmod go+rwx -R "$CONDA_DIR/bin" && chown notebook:notebook -R "$CONDA_DIR/bin" "$HOME" && \
    mkdir -p "$CONDA_DIR/.condatmp" && chmod go+rwx "$CONDA_DIR/.condatmp" && chown notebook:notebook "$CONDA_DIR"

# hadolint ignore=DL3002
RUN chmod go+w -R "$HOME" && chmod o+w /home && rm -r /home/notebook

USER notebook
WORKDIR $HOME
CMD ["/usr/local/bin/start-notebook.sh"]
