# Upstream Dockerfile https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/Dockerfile_tidyverse_4.0.3
FROM rocker/tidyverse:4.0.4

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

# Setup various variables
ENV TZ="Europe/Oslo" \
    USERNAME="rstudio" \
    HOME="/home/rstudio" \
    TINI_VERSION=v0.18.0 \
    APP_UID=999 \
    APP_GID=999 \
    PKG_R_VERSION=4.0.4 \
    PKG_RSTUDIO_VERSION=1.4.1106 \
    PKG_SHINY_VERSION=1.5.16.958

# Setup Tini, as S6 does not work when run as non-root users
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

# Setup Shiny
ADD https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-${PKG_SHINY_VERSION}-amd64.deb /tmp/shiny.deb
RUN gdebi -n /tmp/shiny.deb && \
    rm /tmp/shiny.deb && \
    install2.r -e shiny rmarkdown shinythemes shinydashboard && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    mkdir -p /var/log/shiny-server && \
    chown rstudio.rstudio /var/log/shiny-server && \
    chmod go+w -R /var/log/shiny-server /usr/local/lib/R /srv /var/lib/shiny-server

COPY rserver.conf rsession.conf /etc/rstudio/
COPY start.sh /usr/local/bin/start.sh
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY .Renviron $HOME/.Renviron

RUN chmod go+w -R /home/rstudio && \
    usermod -u 988 rstudio-server && \
    groupmod -g 988 rstudio-server && \
    usermod -u "$APP_UID" rstudio && \
    groupmod -g "$APP_GID" rstudio && \
    chmod -R go+w /tmp/downloaded_packages /etc/rstudio/rsession.conf && \
    chown root:root /var/lib/rstudio-server/rstudio.sqlite


USER $APP_UID:$APP_GID
WORKDIR $HOME
EXPOSE 8787 3838
LABEL maintainer Uninett AS <system@uninett.no>
ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["/usr/local/bin/start.sh"]

