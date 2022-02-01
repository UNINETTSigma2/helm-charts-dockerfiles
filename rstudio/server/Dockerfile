# Upstream Dockerfile https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/tidyverse_4.1.2.Dockerfile

FROM rocker/r-ver:latest

LABEL maintainer Uninett AS <system@uninett.no>

# Setup various variables
ENV TZ="Europe/Oslo" \
    USERNAME="rstudio" \
    HOME="/home/rstudio" \
    TINI_VERSION=v0.19.0 \
    APP_UID=1000 \
    APP_GID=1000 \
    PKG_R_VERSION=4.1.2 \
    PKG_RSTUDIO_VERSION=1.4.1103 \
    PKG_SHINY_VERSION=1.5.17.973 \
    S6_VERSION=v2.1.0.2 \
    RSTUDIO_VERSION=1.4.1717 \
    DEFAULT_USER=rstudio \
    PATH=/usr/lib/rstudio-server/bin:$PATH \
    RSTUDIO_DATA_HOME=$HOME/.rstudio

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh

RUN /rocker_scripts/install_tidyverse.sh

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    apt-utils \
    nano \
    curl \
    libnode64 \
    libbz2-dev \
    liblzma-dev \
    librsvg2-dev \
    openssh-client \
    less \
    htop \
    procps \
    net-tools \
    rsync \
    gdebi-core \
    libxt-dev \
    man-db && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup Tini, as S6 does not work when run as non-root users
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

# Setup Shiny
ADD https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-${PKG_SHINY_VERSION}-amd64.deb /tmp/shiny.deb
COPY shiny-server.conf /etc/init/shiny-server.conf
RUN gdebi -n /tmp/shiny.deb && \
    rm /tmp/shiny.deb && \
    install2.r -e shiny rmarkdown shinythemes shinydashboard && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    mkdir -p /var/log/shiny-server && \
    chown rstudio:rstudio /var/log/shiny-server && \
    chmod go+w -R /var/log/shiny-server /usr/local/lib/R /srv /var/lib/shiny-server

COPY start.sh /usr/local/bin/start.sh
COPY .Renviron $HOME/.Renviron

RUN mkdir -p /tmp/downloaded_packages && \
    chown -R rstudio:rstudio /tmp/downloaded_packages/ && \
    chmod -R 777 /home/rstudio/ /tmp/downloaded_packages/ && \
    mkdir -p /etc/rstudio/ /var/lib/rstudio-server/ /var/run && \
    chown -R rstudio:rstudio /etc/rstudio/ /var/lib/rstudio-server/ /var/run/ && \
    chmod -R 777 /etc/rstudio/ /var/lib/rstudio-server/ /var/run/ && \
    chmod -R 1777 /var/run/rstudio-server/

USER $APP_UID:$APP_GID
WORKDIR $HOME
EXPOSE 8787 3838

ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["/usr/local/bin/start.sh"]
