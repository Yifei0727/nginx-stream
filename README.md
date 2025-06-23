

### how to use

```bash
mkdir /data/
cat >/data/hosts.txt <<EOF
github.com
api.github.com
EOF

docker run --name nginx-stream \
  -d \
  -p 80:80 \
  -p 443:443 \
  -v /data/hosts.txt:/etc/hosts.txt \
  nginx-stream
```

### how to debug

```bash
docker run --rm --entrypoint sh nginx-stream -c "ls /run/"
```