#!/usr/bin/env sh

HOSTS_FILE="/etc/hosts.txt"
STREAM_CONF="/etc/nginx/stream-enabled/stream.conf"

# 如果不存在 hosts 文件则结束
if [ ! -f "$HOSTS_FILE" ]; then
  echo "hosts 文件不存在"
  exit 1
fi

# 清空原有配置
echo ''> "$STREAM_CONF"

# 写入 map 开头，保留 backend_default
echo "map \$ssl_preread_server_name \$backend_name {" >> "$STREAM_CONF"
echo "    default backend_default;" >> "$STREAM_CONF"

# 处理 hosts 文件，忽略空行和#开头的行
grep -vE '^\s*$|^\s*#' "$HOSTS_FILE" | while read -r domain; do
    echo "    $domain $domain;" >> "$STREAM_CONF"
done

echo "}" >> "$STREAM_CONF"
echo "" >> "$STREAM_CONF"

# 写入 upstream
grep -vE '^\s*$|^\s*#' "$HOSTS_FILE" | while read -r domain; do
    cat <<EOF >> "$STREAM_CONF"
upstream $domain {
    server $domain:443;
}
EOF
done

# 写入 backend_default upstream
cat <<EOF >> "$STREAM_CONF"

upstream backend_default {
    server 127.0.0.1:8443;
}

server {
    listen 443;
    proxy_pass \$backend_name;
    ssl_preread on;
}
EOF