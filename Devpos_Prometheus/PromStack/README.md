# Deploy Prometheus Stack with Docker Compose

## 项目介绍

Deploy Prometheus Stack with Docker Compose

## 软件架构

![Prometheus Consul Grafana](imgs/PromStack.png)

## 组件介绍

### Prometheus

[Prometheus](https://prometheus.io/) 是由 SoundCloud 开源监控告警解决方案，从 2012 年开始编写代码，再到 2015 年 github 上开源以来，已经吸引了 18k+ 关注，以及很多大公司的使用；2016 年 Prometheus 成为继 k8s 后，第二名 CNCF(Cloud Native Computing Foundation) 成员。

CNCF announced the graduation status of Prometheus at the PromCon 2018 conference.

Prometheus, an open-source monitoring system and time series database, has become the second project after Kubernetes to graduate from the Cloud Native Computing Foundation (CNCF).

2018 年 CNCF 在 PromCon 2018 上宣布 Prometheus 从 CNCF Graduated ，这是继 Kubernetes 后第二个 Graduated 的成员。

![prometheus architecture](imgs/prometheus-architecture.png)

**它有什么特点？**

+ 自定义多维数据模型(时序列数据由metric名和一组key/value标签组成)
+ 在多维度上灵活且强大的查询语言(PromQl)
+ 不依赖分布式存储，支持单主节点工作
+ 通过基于HTTP的pull方式采集时序数据
+ 可以通过push gateway进行时序列数据推送(pushing)
+ 可以通过服务发现或者静态配置去获取要采集的目标服务器
+ 多种可视化图表及仪表盘支持

### Consul

[Consul](http://www.consul.io/) 是一个分布式服务网格（ service mesh ），用于跨任何运行时平台以及公共云 / 私有云连接的服务发现、服务分割和服务配置。

关键概念：

+ `API-Driven` 对服务定义、运行状况检查、服务授权策略、故障转移逻辑等进行编码和自动化。
+ `Run and Connect Anywhere` 跨任何运行时平台和公共云 / 私有云连接服务。将服务从 Kubernetes 连接到 VM （ Kubernetes to VMs ）、容器到无服务器（ Containers to Serverless ）功能。
+ `Extend and Integrate` 在任何基础架构上配置群集，通过代理集成连接到TLS上的服务，使用可插拔证书颁发机构提供TLS证书。

### Grafana

_The open platform for beautiful analytics and monitoring_

[Grafana](https://grafana.com/) 是一个领先的时序数据（ time series ）分析开源软件，同时提供通用仪表板和告警功能（ Grafana4.0 及之后版本）作为 Web 应用程序运行。它支持 graphite ， InfluxDB 或 opentsdb 作为后端存储。

### Suggested Exporters

+ [node_exporter v0.18.1](https://gitee.com/atompi/node_exporter/releases/v0.18.1)
+ [mysqld_exporter v0.12.1](https://github.com/prometheus/mysqld_exporter/releases/tag/v0.12.1)
+ [redis_exporter v0.34.1](https://github.com/oliver006/redis_exporter/releases/tag/v0.34.1)
+ ~~[nginx-vts-exporter v0.10.6](https://gitee.com/atompi/nginx-vts-exporter/releases/v0.10.6)~~
+ [nginx_exporter](https://github.com/atompi/nginx_exporter)
+ [prometheus-pusher](https://gitee.com/atompi/prometheus-pusher)
+ [blackbox_exporter v0.16.0 / 2019-12-09](https://gitee.com/atompi/blackbox_exporter/releases/v0.16.0-with-cmd)
+ [*_client](https://prometheus.io/docs/instrumenting/clientlibs/)

## 安装文档及使用说明

+ [服务端安装文档](docs/server_installation.md)
+ [agent 安装文档](docs/agent_installation.md)
+ [使用说明](docs/get_started.md)

## 参与贡献

1. Fork 本项目
2. 新建 Feat_xxx 分支
3. 提交代码
4. 新建 Pull Request


## 码云特技

1. 使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2. 码云官方博客 [blog.gitee.com](https://blog.gitee.com)
3. 你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解码云上的优秀开源项目
4. [GVP](https://gitee.com/gvp) 全称是码云最有价值开源项目，是码云综合评定出的优秀开源项目
5. 码云官方提供的使用手册 [http://git.mydoc.io/](http://git.mydoc.io/)
6. 码云封面人物是一档用来展示码云会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
