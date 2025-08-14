# Upstream Dockerfile https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/r-ver_4.3.3.Dockerfile

FROM rocker/r-ver:4.5.1

LABEL maintainer = "contact@sigma2.no"

ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2025.05.1+513
ENV PANDOC_VERSION=default

ENV PATH=/usr/lib/rstudio-server/bin:$PATH

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_tidyverse.sh

# Setup various variables
ENV TZ="Europe/Oslo" \
    USERNAME="rstudio" \
    HOME="/home/rstudio" \
    TINI_VERSION=v0.19.0 \
    APP_UID=977 \
    APP_GID=977 \
    PKG_R_VERSION=4.5.1 \
    PKG_RSTUDIO_VERSION=2025.05.1+513 \
    PKG_SHINY_VERSION=1.5.23.1030

# Setup Tini, as S6 does not work when run as non-root users
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

# Setup Shiny
ADD https://download3.rstudio.org/ubuntu-20.04/x86_64/shiny-server-${PKG_SHINY_VERSION}-amd64.deb /tmp/shiny.deb

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

RUN rstudio-server verify-installation

RUN usermod -u 988 rstudio-server && \
    groupmod -g 988 rstudio-server && \
    usermod -u "$APP_UID" rstudio && \
    groupmod -g "$APP_GID" rstudio && \
    chown -R rstudio:rstudio /home/rstudio && \
    chmod -R go+rwX /home/rstudio /tmp/downloaded_packages /var/lib/rstudio-server /var/log/rstudio && \
    rm /var/lib/rstudio-server/rstudio-os.sqlite


RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    apt-utils \
    nano \
    curl \
    libnode109 \
    libbz2-dev \
    liblzma-dev \
    librsvg2-dev \
    libudunits2-dev \
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


USER $APP_UID:$APP_GID
WORKDIR $HOME
EXPOSE 8787 3838

ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["/usr/local/bin/start.sh"]
