
# Upstream Dockerfile https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/tidyverse_4.1.2.Dockerfile

FROM rocker/r-ver:4.2.3

LABEL maintainer Uninett AS <system@uninett.no>

ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2023.03.0+386
ENV PATH=/usr/lib/rstudio-server/bin:$PATH

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
    man-db \
    strace \
    libglpk-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup various variables
ENV TZ="Europe/Oslo" \
    USERNAME="rstudio" \
    HOME="/home/rstudio" \
    TINI_VERSION=v0.19.0 \
    APP_UID=999 \
    APP_GID=999 \
    PKG_R_VERSION=4.2.3 \
    PKG_RSTUDIO_VERSION=2023.03.0+386 \
    PKG_SHINY_VERSION=1.5.20.1002

# Setup Tini, as S6 does not work when run as non-root users
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

# Setup Shiny
ADD https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-${PKG_SHINY_VERSION}-amd64.deb /tmp/shiny.deb

COPY shiny-server.conf /etc/init/shiny-server.conf
RUN gdebi -n /tmp/shiny.deb && \
    rm /tmp/shiny.deb && \
    install2.r -e shiny rmarkdown shinythemes shinydashboard && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    mkdir -p /var/log/shiny-server && \
    chown rstudio:rstudio /var/log/shiny-server && \
    chmod go+w -R /var/log/shiny-server /usr/local/lib/R /srv /var/lib/shiny-server && \
    chmod ugo+rwx -R /usr/lib/rstudio-server/www

COPY start.sh /usr/local/bin/start.sh

RUN usermod -u 988 rstudio-server && \
    groupmod -g 988 rstudio-server && \
    usermod -u "$APP_UID" rstudio && \
    groupmod -g "$APP_GID" rstudio && \
    chown -R rstudio:rstudio /home/rstudio && \
    chmod -R go+w /home/rstudio /tmp/downloaded_packages /var/lib/rstudio-server /var/log/rstudio

USER root

RUN rstudio-server verify-installation

USER $APP_UID:$APP_GID
WORKDIR $HOME
EXPOSE 8787 3838

ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["/usr/local/bin/start.sh"]
