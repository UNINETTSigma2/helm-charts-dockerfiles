FROM debian:stretch

ENV DOKUWIKI_VERSION 2017-02-19e
ENV DOKUWIKI_MD5 09bf175f28d6e7ff2c2e3be60be8c65f

ENV DOKUWIKI_OAUTH_PLUGIN_MD5 85e69223ff52a39c14bf770e49119e75

ENV LAST_MODIFIED 2017-10-04

# Update & install packages & cleanup afterwards
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install wget unzip lighttpd libterm-readline-gnu-perl tree && \
    apt-get -y install php7.0-xml php7.0-cgi php7.0-gd php7.0-curl && \
    apt-get clean autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/{apt,dpkg,cache,log}

RUN which unzip
# Download & check & deploy dokuwiki & cleanup
RUN wget -q -O /dokuwiki.tgz "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" && \
    if [ "$DOKUWIKI_MD5" != "$(md5sum /dokuwiki.tgz | awk '{print($1)}')" ];then echo "Wrong md5sum of downloaded file!"; exit 1; fi && \
    mkdir /dokuwiki && \
    tar -zxf dokuwiki.tgz -C /dokuwiki --strip-components 1 && \
    rm dokuwiki.tgz

# Get plugins
RUN wget -q -O /oauth.zip https://github.com/cosmocode/dokuwiki-plugin-oauth/archive/master.zip
RUN if [ "$DOKUWIKI_OAUTH_PLUGIN_MD5" != "$(md5sum /oauth.zip | awk '{print($1)}')" ];then echo "Wrong md5sum of downloaded file!"; exit 1; fi
RUN    unzip /oauth.zip && mv dokuwiki-plugin-oauth-master /dokuwiki/lib/plugins/oauth

# Set up ownership
RUN chown -R www-data:www-data /dokuwiki

# Configure lighttpd
RUN lighty-enable-mod fastcgi accesslog
ADD dokuwiki.conf /etc/lighttpd/lighttpd.conf
RUN mkdir /var/run/lighttpd && chown www-data.www-data /var/run/lighttpd

# Configure dokuwiki
ADD local.php /dokuwiki/conf

ADD run.sh ./
RUN chmod a+x ./run.sh

#EXPOSE 80
#VOLUME ["/dokuwiki/data/","/dokuwiki/lib/plugins/","/dokuwiki/conf/","/dokuwiki/lib/tpl/","/var/log/"]

CMD ./run.sh
