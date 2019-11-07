FROM kitware/paraviewweb:pvw-v5.7.0-rc2-osmesa

# Make it possible to run Apache2 as a non-root user.
# TODO: Run as nobody, or www-data, maybe?
RUN mkdir -p /var/run/apache2 && \
    chown -R 999:999 /var/run/apache2* && \
    chown -R 999:999 /var/run/apache2* && \
    chmod -R g+w /var/run/apache2*     && \
    chown -R 999:99 /var/log/apache2
RUN groupadd -g 999 paraview && useradd -o -u 999 -g 999 paraview
COPY config/launcher/config-template.json /opt/launcher/config-template.json
COPY config/apache/001-pvw.conf /etc/apache2/sites-available/001-pvw.conf
COPY config/apache/envvars /etc/apache2/
COPY config/apache/ports.conf /etc/apache2
COPY scripts/start.sh /opt/paraviewweb/scripts/
RUN curl http://us.download.nvidia.com/XFree86/Linux-x86_64/410.93/NVIDIA-Linux-x86_64-410.93.run -o nvidia.run && chmod +x nvidia.run
RUN apt update && apt install -y kmod
RUN ./nvidia.run --ui=none -q --no-kernel-module --no-x-check --no-nvidia-modprobe

RUN ["/opt/paraviewweb/scripts/addEndpoints.sh", \
    "visualizer", "/opt/paraview/share/paraview-5.7/web/visualizer/www" \
]

EXPOSE 8080
ENTRYPOINT ["/opt/paraviewweb/scripts/start.sh"]
