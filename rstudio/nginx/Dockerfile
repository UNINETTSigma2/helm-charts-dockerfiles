FROM nginx:1.13-alpine

LABEL maintainer Uninett As <system@uninett.no>
COPY *.html /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/
USER nobody
CMD ["nginx", "-g", "daemon off;"]