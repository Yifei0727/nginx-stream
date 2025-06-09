#!/usr/bin/env sh
mkdir -p /etc/nginx/sites-enabled/
echo '
server {
    server_name _;
    location / {
        return 403;
    }

    listen 8443      default_server ssl ;
    listen [::]:8443 default_server ssl ;
    ssl_certificate     /etc/ssl/nginx/default.cer;
    ssl_certificate_key /etc/ssl/nginx/default.key;
}' >/etc/nginx/sites-enabled/default
NGINX_SSL_DIR=/etc/ssl/nginx
TMP_DIR="/tmp/$(date '+%Y%m%d%H%M%S')$(uuidgen)/"
mkdir "$TMP_DIR" && cd "$TMP_DIR" || echo "Failed to create temporary directory"
openssl req -new -x509 -newkey rsa:2048 -out default.cer -keyout default.key -nodes -subj "/CN=default" -days 30
mkdir -p "$NGINX_SSL_DIR/"
mv default.cer  default.key "$NGINX_SSL_DIR/"
nginx -s reload