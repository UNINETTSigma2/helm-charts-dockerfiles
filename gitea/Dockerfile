###################################
#Build stage
FROM gitea/gitea:1.6

RUN mkdir /home/gitea && chmod go+w -R /home

COPY entrypoint.sh /usr/local/bin
COPY setup /etc/s6/gitea

RUN chmod a+x /usr/local/bin/entrypoint.sh

EXPOSE 22 3000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
