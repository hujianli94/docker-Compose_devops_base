## 服务端安装教程

1. 创建目录：

    + `mkdir -p /data/PromStack/prometheus/{data,conf/blackbox_targets}`
    + `mkdir -p /data/PromStack/grafana/{data,conf}`
    + `mkdir -p /data/PromStack/nginx/logs`
    + `mkdir -p /data/PromStack/consul/data`

2. 复制配置文件到指定目录（详见 [docker-compose.yml](docker-compose.yml) volume 结构）并修改配置

```
cp conf/prometheus/prometheus.yml /data/PromStack/prometheus/conf/prometheus.yml
cp -r conf/prometheys/blackbox_targets /data/PromStack/prometheus/conf/
cp conf/grafana/{grafana.ini,ldap.toml} /data/PromStack/grafana/conf/
cp -r conf/nginx/conf /data/PromStack/nginx/conf
```

+ grafana

修改 `grafana.ini` 中 `domain` `root_url` `smtp` 三个部分配置即可（若需要更高级的配置，自行修改相应配置文件即可）

修改 grafana 持久化目录用户及用户组为 `472:472`

```
chown -R 472:472 /data/PromStack/grafana
```

+ prometheus

修改 prometheus 持久化目录用户及用户组为 `65534:65534`

```
chown -R 65534:65534 /data/PromStack/prometheus
```

+ nginx

修改 `conf.d/grafana.conf` 中 `server_name` 并根据需求配置是否开启 `https` ， ssl 端口及证书配置在 `ssl.d/ssl.conf` 中

若使用外部 nginx 则需要将 `conf.d/grafana.conf` 中 `proxy_pass` 改为 grafana 所在服务器的内网 IP ，端口为 30030 （在 `docker-compose_without-nginx.yml` 中配置），并将 `conf.d/grafana.conf` 上传到外部 nginx 配置中.

3. 启动服务：

```
# 创建 docker network
docker network create promstack_net -d bridge
# 启动服务
cd PromStack
docker-compose up -d
```

4. 卸载服务：

```
# 完全卸载（删除 consul volume ）
# cd PromStack
# docker-compose down -v
# 删除容器，保留数据（保留 consul volume ）
# cd PromStack
# docker-compose down
```
