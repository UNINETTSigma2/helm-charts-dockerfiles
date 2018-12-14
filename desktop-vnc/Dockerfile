# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM ubuntu:16.04

MAINTAINER Simon Hofmann "simon.hofmann@consol.de"
ENV REFRESHED_AT 2018-10-29

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Install some common tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    locales \
    chromium-browser chromium-browser-l10n \
    chromium-codecs-ffmpeg vim wget net-tools \
    locales bzip2 python-numpy ttf-wqy-zenhei \
    supervisor xfce4 xfce4-terminal xterm \
    libnss-wrapper gettext \
    && apt-get clean -y

RUN locale-gen en_US.UTF-8

ADD ./src/common/install/ $INST_SCRIPTS/
ADD ./src/ubuntu/install/ $INST_SCRIPTS/

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh && \
    $INST_SCRIPTS/no_vnc.sh &&   \
    $INST_SCRIPTS/firefox.sh &&  \
    $INST_SCRIPTS/chrome.sh &&   \
    $INST_SCRIPTS/libnss_wrapper.sh

# configure startup
ADD ./src/common/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

USER 1000

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
