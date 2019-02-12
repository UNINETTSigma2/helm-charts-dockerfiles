FROM gitea/gitea:1.6

RUN mkdir -p /home/gitea /data/git /etc/gitea /var/lib/gitea && \
    chmod a+w /etc/gitea && \
    chmod a+w /var/lib/gitea && \
    chmod a+w -R /home && \
    chmod a+w /app/gitea

COPY entrypoint.sh /usr/local/bin
COPY setup /etc/s6/gitea

EXPOSE 22 3000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
