# Upstream Dockerfile https://github.com/rocker-org/rocker-versioned/blob/master/tidyverse/3.4.4/Dockerfile
FROM rocker/tidyverse:3.4.4

RUN apt-get update && apt-get install --no-install-recommends -y nano=2.7.4-1 \
 curl=7.52.1-5+deb9u5 \
 git=1:2.11.0-3+deb9u2 \
 openssh-client=1:7.4p1-10+deb9u3 \
 less=481-2.1 \
 htop=2.0.2-1 \
 procps=2:3.3.12-3 \
 net-tools=1.60+git20161116.90da8a0-1 \
 rsync=3.1.2-1+deb9u1 && \
 apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup locales
ENV TZ Europe/Oslo

# Setup Tini, as S6 does not work when run as non-root users
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

# Setup ENV for Appstore to be picked up
ENV APP_UID 988
ENV APP_GID 988
ENV PKG_R_VERSION 3.4.4
ENV PKG_RSTUDIO_VERSION 1.1.447

RUN chmod go+w -R /home/rstudio
COPY rserver.conf /etc/rstudio/rserver.conf
USER $APP_UID:$APP_GID
WORKDIR /mnt
EXPOSE 8787
LABEL maintainer Uninett AS <system@uninett.no>
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize", "0", "--auth-none", "0"]

