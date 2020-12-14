## 使用说明

1. 服务端配置修改：

    + 修改相应的配置文件
    + 重启 service ： cd 到服务端安装目录（ docker-compose.yml 所在目录），然后执行 `docker-compose restart <service-name>`

2. 注册 Exporter 到 Consul ：

无 metadata （ `$(hostname)` 就是一个命令，不是变量，不要修改）

以 `node_exporter` 为例，其它 exporter 区别在于： `-node` 对应于 exporter 的前缀， `--tags=` 对应于 exporter 的全称

`--consul=` 为服务端地址，根据实际修改 `:8500` 为 consul 默认端口，如果没有修改服务端 docker-compose.yml consul 的映射端口，则不需要修改端口

```
bash register_exporter.sh --id=$(hostname)-node --name=$(hostname)-node --address=$(hostname) --port=9101 --tags='"node_exporter"' --consul=192.168.2.58:8500
```

含 metadata **目前不用**

```
bash register_exporter_with_metadata.sh --id=$(hostname)-blackbox --name=$(hostname)-blackbox --address=$(hostname) --port=9115 --tags='"blackbox_exporter"' --consul=192.168.2.58:8500 --meta='"meta":{"module":"http_2xx","target":"https://baidu.com"}'
```

3. 将 Exporter 从 Consul 中移除（同时回从 Prometheus Server 中移除对此 Exporter 的 metrics 数据的拉取）

```
# 将 service monitor-node 移除
curl  --request PUT  http://localhost:8500/v1/agent/service/deregister/monitor-node
```

*. 访问 grafana

    + 浏览器访问： https://gf.domain.name
    + dashboard 可以浏览器导入，插件安装具体操作见[官方文档](http://docs.grafana.org/plugins/installation/)

4. 对于使用了 `blackbox_exporter` 的 Prometheus 服务端需要进行特殊配置

`blackbox_exporter` 的 `metrics_path` 不是通常的 `/metrics` ，而是 `/probe` ，同时通过传入参数 `module` 和 `target` 来获取指标数据。

因此需要对服务端 Prometheus 进行相关配置才能获取 `blackbox_exporter` 的监控数据，配置如下：

```
# Blackbox Exporter
  - job_name: 'hostA_blackbox'
    metrics_path: /probe
    file_sd_configs:
      - files:
        - '/etc/prometheus/blackbox_targets/hostModuleA/*.yml'
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [module]
        target_label: __param_module
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: <hostA_ip>:9115  # blackbox exporter's host:port

  - job_name: 'hostB_blackbox'
    metrics_path: /probe
    file_sd_configs:
      - files:
        - '/etc/prometheus/blackbox_targets/hostModuleB/*.yml'
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [module]
        target_label: __param_module
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: <hostB_ip>:9115  # blackbox exporter's host:port
# End Blackbox Exporter
```

在 `/data/PromStack/prometheus/conf/blackbox_targets` 目录（ Prometheus 服务端配置文件的 docker 容器挂载目录 ）创建 `file_sd_configs` 配置文件，用于支持在同一个 `job` 内配置多个 `module` 及多个 `target` （每个 `module` 一个 `yml` 文件）

如：

+ `http_2xx.yml`

```
- labels:
    module: http_2xx
  targets:
  - https://www.oschina.net/
```

+ `tcp_connect.yml`

```
- labels:
    module: tcp_connect
  targets:
  - 127.0.0.1:8080
```

+ `my_cmd_status.yml`

```
- labels:
    module: my_cmd_status
  targets:
  - my_cmd_status
```
