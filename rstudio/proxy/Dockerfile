FROM nginx:1.31.3-alpine

LABEL maintainer="contact@sigma2.no"
# Add TINI
RUN apk add --no-cache tini=0.19.0-r3

COPY nginx.conf /etc/nginx/

USER nobody
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["nginx", "-g", "daemon off;"]
