FROM aiidalab/aiidalab-docker-stack:latest
# Prevent some services from starting, as they require root
RUN rm /etc/my_init.d/20_start-rabbitmq.sh \
       /etc/my_init.d/30_start-postgres.sh \
       /etc/my_init.d/10_syslog-ng.init \
       /etc/my_init.post_shutdown.d/10_syslog-ng.shutdown \
       /etc/my_init.d/10_create-system-user.sh && \
       rm -r /etc/service/cron/

ENV APP_UID=999 \
    APP_GID=999 \
    SYSTEM_USER=notebook \
    HOME=/home/notebook \
    SETUP_DEFAULT_PROFILE=true \
    RABBITMQ_CONFIG_FILE=/home/notebook/config/rabbitmq \
    RABBITMQ_SERVER_ERL_ARGS="-setcookie rabbit" \
    RABBITMQ_CTL_ERL_ARGS="-setcookie rabbit" \
    PROFILE_NAME=default

# We here create the user instead of using 10_create-system-user
RUN groupadd -g "$APP_GID" notebook && \
  useradd -m -s /bin/bash -N -u "$APP_UID" -g notebook notebook && \
  usermod -G users notebook

RUN chown 999:999 -R /etc/container_environment* /etc/service /etc/runit/runsvdir/default /var/run /var/log && chown 999:999 /opt /var/run /etc/syslog-ng /home
COPY opt/* /opt/
RUN chown 999:999 -R /opt/aiidalab-home

COPY etc/service/jupyter-notebook/run /etc/service/jupyter-notebook/run

# Replace the AiiDA startup scripts for RabbitMQ and Postgresql with local ones
COPY my_init.d/start-rabbitmq.sh /etc/my_init.d/20_start-rabbitmq.sh
COPY my_init.d/start-postgres.sh /etc/my_init.d/30_start-postgres.sh

RUN mkdir -p /home/notebook/.aiida && ln -s /home/notebook /home/aiida && chown -R 999:999 /home/notebook /home/aiida /usr/lib/rabbitmq/ /var/lib/rabbitmq
COPY my_init.d/configure-aiida.sh /etc/my_init.d/40_configure-aiida.sh
COPY my_init.d/prepare-aiidalab.sh /etc/my_init.d/80_prepare-aiidalab.sh
COPY my_init.d/create-app-dirs.sh /etc/my_init.d/01_create-app-dirs.sh

# Remove the rabbitmq server that requires root, as we instead want to use the one stored in /usr/lib/rabbitmq/bin/
RUN mv /usr/sbin/rabbitmqctl /usr/sbin/dont_use_abbitmqctl && \
    mv /usr/sbin/rabbitmq-plugins /usr/sbin/dont_use_rabbitmq-plugins && \
    mv /usr/sbin/rabbitmq-server /usr/sbin/dont_use_rabbitmq-server
