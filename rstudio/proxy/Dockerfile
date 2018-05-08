FROM nginx:1.13-alpine

LABEL maintainer Uninett As <system@uninett.no>
# Add TINI
RUN apk add --no-cache tini=0.16.1-r0

COPY index.html /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/

USER nobody
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["nginx", "-g", "daemon off;"]