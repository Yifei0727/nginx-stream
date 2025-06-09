#!/usr/bin/env sh

# 初始化构建DOCKER 时配置 重新调整nginx的配置参数
cd nginx || echo "nginx source dir missing"
### 1. worker_processes 1; -> worker_processes auto;
sed -i 's/^\(\s*worker_processes\)\s\+1;/\1  auto;/' conf/nginx.conf
### 2. worker_connections 1024; -> worker_connections 65535;
sed -i 's/^\(\s*worker_connections\)\s\+1;/\1  65535;/' conf/nginx.conf

### 4. 新的 http 配置内容
NEW_HTTP_BLOCK=$(cat <<'EOF'
http {
    include       mime.types;
    default_type  application/octet-stream;
    types_hash_max_size 2048;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    ssl_protocols TLSv1.2 TLSv1.3 TLSv1; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;

    keepalive_timeout  65;

    include /etc/nginx/sites-enabled/*;

}
EOF
)

# 查找所有 nginx 配置文件并替换 http 段
export NGX_CNF="conf/nginx.conf"
if grep -q "http\s*{" "$NGX_CNF"; then
  # 使用 perl 替换 http 段
  perl -0777 -i -pe "s/http\s*\{.*?\n\}/$NEW_HTTP_BLOCK\n/s" "$NGX_CNF"
  echo "已替换: $NGX_CNF"
fi

###
echo 'stream {
   include /etc/nginx/stream-enabled/*;
   error_log /var/log/nginx/stream.log;
}' >>conf/nginx.conf