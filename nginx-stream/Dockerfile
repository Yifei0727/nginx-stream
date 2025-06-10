# Use a smaller base image
FROM alpine:3.18
RUN \
    mkdir -p /usr/share/nginx ;\
    mkdir -p /usr/lib/nginx/modules ;\
    mkdir -p /etc/nginx ;\
    mkdir -p /var/lock ;\
    mkdir -p /var/log/nginx ;\
    mkdir -p /var/lib/nginx/body ;\
    mkdir -p /var/lib/nginx/fastcgi ;\
    mkdir -p /var/lib/nginx/proxy ;\
    mkdir -p /var/lib/nginx/scgi ;\
    mkdir -p /var/lib/nginx/uwsgi

COPY nginx/conf/*            /etc/nginx/
COPY nginx/html              /usr/share/nginx/
#COPY nginx/objs/*.so         /usr/share/nginx/modules/
COPY update-hosts.sh   /bin/update-hosts.sh
COPY update-ssl.sh     /bin/update-ssl.sh
RUN \
    apk add --no-cache openssl ca-certificates ;\
    update-ca-certificates ;\
    chmod +x /bin/update-hosts.sh ;\
    chmod +x /bin/update-ssl.sh \
