## 安装教程

1. 创建目录：

    + `/usr/local/prometheus-pusher`
    + `/data/nginx/logs`
    + `/data/nginx/conf/stream.d`

2. 复制配置文件到指定目录，详见 [docker-compose.yml](docker-compose.yml) volume 结构

3. 启动服务：

```
# cd ~/PromStack/pushgateway-support
# docker-compose up -d
```

4. 卸载服务：

```
# 完全卸载（删除 volumes ）
# cd ~/PromStack/pushgateway-support
# docker-compose down -v
# 删除容器，保留数据（保留 volumes ）
# cd ~/PromStack/pushgateway-support
# docker-compose down
```

5. 向 prometheus-pusher 注册/移除 exporter

```
# 注册 exporter
curl -X PUT -d '{"id": "-monitor-node","name": "my-monitor-node","address": "my-monitor-node","port": 9100,"tags": ["my_node_exporter"],"checks": [{"http": "http://my-monitor-node:9100/","interval": "5s"}]}' http://my-monitor:8500/v1/agent/service/register
# 移除 exporter
curl  --request PUT  http://localhost:8500/v1/agent/service/deregister/my-monitor-node
```

6. 查看 prometheus-pusher targets 状态

```
curl http://localhost:9191/targets
```
