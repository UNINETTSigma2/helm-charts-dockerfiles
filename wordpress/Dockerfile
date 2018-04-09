FROM centos:7
RUN yum -y install epel-release mariadb php php-mysql php-mbstring unzip && yum -y install lighttpd lighttpd-fastcgi
ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp
WORKDIR /usr/local/www/wp
RUN wp core download
COPY dist/ /
# From here we need a working MySQL server, which we won't have if we're in the building phase,
# so the rest of the building must happen in the CMD phase.  yay.
CMD /root/init.sh
