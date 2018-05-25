# Upstream Dockerfile https://github.com/rocker-org/rocker-versioned/blob/master/tidyverse/3.4.4/Dockerfile
FROM rocker/tidyverse:3.4.4

RUN apt-get update && apt-get install --no-install-recommends -y \
    nano=2.7.4-1 \
    curl=7.52.1-5+deb9u6 \
    openssh-client=1:7.4p1-10+deb9u3 \
    less=481-2.1 \
    htop=2.0.2-1 \
    procps=2:3.3.12-3 \
    net-tools=1.60+git20161116.90da8a0-1 \
    rsync=3.1.2-1+deb9u1 \
    gdebi-core=0.9.5.7+nmu1 \
    libxt-dev=1:1.1.5-1 \
    man-db=2.7.6.1-2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup various variables
ENV TZ="Europe/Oslo" \
    TINI_VERSION=v0.18.0 \
    APP_UID=999 \
    APP_GID=999 \
    PKG_R_VERSION=3.4.4 \
    PKG_RSTUDIO_VERSION=1.1.447 \
    PKG_SHINY_VERSION=1.5.7.907


# Setup Tini, as S6 does not work when run as non-root users
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

# Setup Shiny
ADD https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-${PKG_SHINY_VERSION}-amd64.deb /tmp/shiny.deb
RUN gdebi -n /tmp/shiny.deb && \
    rm /tmp/shiny.deb && \
    install2.r -e shiny rmarkdown && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    mkdir -p /var/log/shiny-server && \
    chown rstudio.rstudio /var/log/shiny-server && \
    chmod go+w -R /var/log/shiny-server /usr/local/lib/R /srv/shiny-server /var/lib/shiny-server

RUN chmod go+w -R /home/rstudio && \
    usermod -u 988 rstudio-server && \
    groupmod -g 988 rstudio-server && \
    usermod -u "$APP_UID" rstudio && \
    groupmod -g "$APP_GID" rstudio

COPY rserver.conf rsession.conf /etc/rstudio/
COPY start.sh /usr/local/bin/start.sh
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

USER $APP_UID:$APP_GID
WORKDIR /mnt
EXPOSE 8787 3838
LABEL maintainer Uninett AS <system@uninett.no>
ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["/usr/local/bin/start.sh"]

