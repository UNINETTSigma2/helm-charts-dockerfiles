FROM nginx:1.25.3-alpine

LABEL maintainer Uninett As <system@uninett.no>
# Add TINI
RUN apk add --no-cache tini=0.19.0-r0

COPY nginx.conf /etc/nginx/

USER nobody
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["nginx", "-g", "daemon off;"]
