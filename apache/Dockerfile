FROM rockylinux/rockylinux:8


RUN dnf -y --setopt=tsflags=nodocs update && \
    dnf -y --setopt=tsflags=nodocs install httpd && \
    dnf clean all && \
    sed -i  "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf

# Run on port 8080
EXPOSE 8080

# Access logs and runtime files
RUN chgrp 48 /var/{log,run}/httpd &&   \
    chmod g+rwx /var/{log,run}/httpd

# Simple startup script to avoid some issues observed with container restart
COPY run-httpd.sh /run-httpd.sh
RUN chgrp 48 /run-httpd.sh && chmod g+rx /run-httpd.sh

COPY project.conf /etc/httpd/conf.d/
RUN chown 48 /etc/httpd/conf.d/project.conf &&   \
    mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf-donot-use &&   \
    mv /etc/httpd/conf.modules.d/01-cgi.conf /etc/httpd/conf.modules.d/01-cgi.conf.disable &&   \
    echo "Europe/Oslo" > /etc/timezone
# Fix timezone
ENV TZ="Europe/Oslo"

# Run as user apache
USER 48
  
CMD ["/run-httpd.sh"]
