FROM nginx:1.21.5-alpine

LABEL maintainer Uninett As <system@uninett.no>
# Add TINI
RUN apk add --no-cache tini=0.19.0-r0


COPY index.html /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/

RUN chmod -R go+rw /var/log/nginx

USER nobody
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["nginx", "-g", "daemon off;"]
