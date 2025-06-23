# Use a smaller base image
FROM ubuntu:22.04
WORKDIR /app/
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
    mkdir -p /var/lib/nginx/uwsgi ;\
    mkdir -p /var/cache/nginx ;\
    mkdir -p /var/run ;\
    mkdir -p /var/spool/cron/crontabs ;\
    mkdir -p /etc/nginx/stream-enabled/
RUN ln -sf /var/run /run
COPY nginx/conf/*            /etc/nginx/
COPY nginx/html              /usr/share/nginx/
#COPY nginx/objs/*.so         /usr/share/nginx/modules/
COPY nginx/objs/nginx        /usr/sbin/nginx
COPY update-ssl.sh           /usr/bin/update-ssl.sh
COPY nginx-start.sh          /app/nginx-start.sh
RUN \
    apt update && apt upgrade -y ;\
    apt install -y binutils openssl uuid-runtime build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libxml2-dev libxslt-dev libgd-dev cron ;\
    chmod +x /usr/sbin/nginx ;\
    chmod +x /usr/bin/update-ssl.sh ;\
    chmod +x /app/nginx-start.sh ;\
    echo "0 0 * * * /usr/bin/update-ssl.sh >> /var/log/cron.log 2>&1" > /var/spool/cron/crontabs/root

ENTRYPOINT ["sh", "-c", "/app/nginx-start.sh"]