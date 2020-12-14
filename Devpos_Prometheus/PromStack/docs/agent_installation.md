## agent 安装教程

### agent 包列表

```
blackbox_exporter-osc-0.16.0.linux-amd64.tar.gz    # 二次开发的，通用于 Gitee 的 blackbox_exporter
blackbox_exporter-sto-0.16.0.linux-amd64.tar.gz    # 二次开发的，已添加适用于 sto 服务器配置文件的 blackbox_exporter
node_exporter-osc-0.18.1.linux-amd64.tar.gz        # 通用于 Gitee 的 node_exporter
node_exporter-sto-0.18.1.linux-amd64.tar.gz        # 已添加适用于 sto 服务器配置文件的 node_exporter
mysqld_exporter-osc-0.12.1.linux-amd64.tar.gz      # 通用于 Gitee 的 mysqld_exporter
redis_exporter-osc-v0.34.1.linux-amd64.tar.gz      # 通用于 Gitee 的 redis_exporter
nginx_exporter_osc.tar.gz                          # 通用于 Gitee 的 nginx_exporter
```

### 全局设置

1. 创建目录：

    + `sudo mkdir -p /opt/promExporters`

2. 复制 `exporter` 文件包到 `/opt/promExporters` 目录，并为每个 `exporter` 解压为一个单独的目录

如 `node_exporter` ：

```
cp node_exporter-0.18.1.linux-amd64.tar.gz /opt/promExporters/
cd /opt/promExporters
mkdir node_exporter
tar -zxf node_exporter-0.18.1.linux-amd64.tar.gz --strip 1 -C node_exporter/
```

所以，最终目录结构为：

```
/opt/
└── promExporters/
    └── node_exporter/
```

### Exporters' setup

+ node_exporter

对于非 sto 服务器，使用 `node_exporter-osc-0.18.1.linux-amd64.tar.gz` 包，不需要配置，启动即可。

启动脚本 `start_node_exporter.sh` ：

```
#!/bin/bash
nohup ./node_exporter --web.listen-address=":9101" > ./node_exporter.log &
```

启动命令： `cd /opt/promExporters/node_exporter && bash start_node_exporter.sh`

对于 sto 服务器，需要设置自定义监控项，这时使用 `node_exporter-sto-0.18.1.linux-amd64.tar.gz` 包，该包下包含所需的配置文件和脚本

```
textfile_collector_scripts/get_sidekiq_queue_size.sh    # 生成自定义监控的脚本， node_exporter 按文档要求安装在 /opt/promExporters 目录下时，不需要修改，否则要修改脚本中的目录 /opt/promExporters 为对应目录
```

同时设置服务器 crontab ，用于自动获取自定义监控值

```
* * * * * git /bin/bash /opt/promExporters/node_exporter/textfile_collector_scripts/get_sidekiq_queue_size.sh
```

启动脚本文件名同上，文件内容：

```
#!/bin/bash
nohup ./node_exporter --web.listen-address=":9101" --collector.textfile.directory="/opt/promExporters/node_exporter/textfiles" > ./node_exporter.log &
```

启动命令同上

+ mysqld_exporter

在 `mysqld_exporter/` 目录下创建 `.my.cnf` 配置文件，用来设置连接 `mysql` 的验证信息。内容格式如下：

```
[client]
host=192.168.1.195
user=exporter
password=123456
```

启动脚本 `start_mysqld_exporter.sh` ：

```
#!/bin/bash
nohup ./mysqld_exporter --config.my-cnf="./.my.cnf" --collect.info_schema.processlist > ./mysqld_exporter.log &
```

启动命令： `cd /opt/promExporters/mysqld_exporter && bash start_mysqld_exporter.sh`

+ ~~nginx_vts_exporter 已弃用，仅作参考~~

<strike>
需要 nginx 支持 [`nginx-module-vts`](https://github.com/vozlt/nginx-module-vts) 模块。

1. 为 nginx 添加 `nginx-module-vts` 模块：

```
cd /tmp
mkdir nginx
cd nginx
wget http://nginx.org/download/nginx-1.16.1.tar.gz
tar -zxf nginx-1.16.1.tar.gz
git clone https://gitee.com/atompi/nginx-module-vts
cd nginx-1.16.1
./configure --prefix=/usr/local/nginx --with-http_gzip_static_module --with-http_ssl_module --with-http_v2_module --with-http_stub_status_module --with-http_realip_module --with-file-aio --with-threads --with-stream --with-stream_ssl_preread_module --with-stream_ssl_module --with-stream_realip_module --add-module=/home/atompi/tempdir/nginx/nginx-module-vts
make
```

编译后的 nginx 二进制文件位于 `objs/nginx` ，若 nginx 已安装，可使用编译后的二进制文件替换原 nginx 二进制文件，然后重启即可。若此前没有安装 nginx 可通过以下命令安装到 `--prefix` 参数指定的目录

```
sudo make install
```

2. 修改 nginx 配置，添加 `vts` 配置

见[配置说明](https://gitee.com/atompi/nginx-module-vts#directives)

启动脚本 `start_nginx_vts_exporter.sh` ：

```
#!/bin/bash
nohup ./nginx-vts-exporter -nginx.scrape_uri=http://localhost:8800/status/format/json > ./nginx-vts-exporter.log &
```

启动命令： `cd /opt/promExporters/nginx_vts_exporter && bash start_nginx_vts_exporter.sh`
</strike>

+ nginx_exporter

需要 nginx 支持 `ngx_http_stub_status_module` 模块

1. 检查 nginx 是否已添加 `ngx_http_stub_status_module` 模块，如果没有，为 nginx 添加 `ngx_http_stub_status_module` 模块：

```
# 检查
nginx -V # 输出中包含 --with-http_stub_status_module 字样
# 编译
cd /tmp
mkdir nginx
cd nginx
wget http://nginx.org/download/nginx-1.16.1.tar.gz
tar -zxf nginx-1.16.1.tar.gz
cd nginx-1.16.1
./configure --prefix=/usr/local/nginx --with-http_gzip_static_module --with-http_ssl_module --with-http_v2_module --with-http_stub_status_module --with-http_realip_module --with-file-aio --with-threads --with-stream --with-stream_ssl_preread_module --with-stream_ssl_module --with-stream_realip_module
make
```

编译后的 nginx 二进制文件位于 `objs/nginx` ，若 nginx 已安装，可使用编译后的二进制文件替换原 nginx 二进制文件，然后重启即可。若此前没有安装 nginx 可通过以下命令安装到 `--prefix` 参数指定的目录

```
sudo make install
```

2. 修改 nginx 配置，添加 `sub_status` 配置

```
server {
    listen 80;
    server_name localhost;

    location /nginx_status {
        stub_status on;
        access_log off;
        allow 192.168.2.0/24;
        allow 127.0.0.1;
        deny all;
    }
}
```

启动脚本 `start_nginx_exporter.sh` ：

```
#!/bin/bash
nohup ./nginx_exporter -telemetry.address=:9103 -nginx.scrape_uri=http://127.0.0.1/nginx_status > ./nginx_exporter.log &
```

启动命令： `cd /opt/promExporters/nginx_exporter && bash start_nginx_exporter.sh`

+ redis_exporter

无需配置，启动即可

启动脚本： `start_redis_exporter.sh`

```
#!/bin/bash
nohup ./redis_exporter -redis.addr=localhost:6379 > ./redis_exporter.log &
```

启动命令： `cd /opt/promExporters/redis_exporter && bash start_redis_exporter.sh`

+ blackbox_exporter

**配置说明，快速部署时可跳过不看**

创建配置文件 `blackbox.yml` ，模板如下：

```
modules:
  http_2xx:
    prober: http
    http:
      method: GET
      preferred_ip_protocol: ipv4
      headers:
        User-Agent: OSC_blackbox_exporter

  tcp_connect:
    prober: tcp

  my_cmd_status:
    prober: cmd
    timeout: 2s
    cmd:
      executable: "/bin/bash"
      cmdline:
        - "echo 1"

  my_script_status:
    prober: cmd
    timeout: 2s
    cmd:
      scriptMode: true
      executable: "/bin/bash"
      scriptPath: "./check_status.sh"
      cmdline:
        - "arg1"
        - "arg2"
```

**如果启用 `cmd prober` 并开启 `scriptMode` 时，建议将脚本文件放置在 `blackbox_exporter` 同目录下**

对于非 sto 服务器，按需启动 blackbox_exporter ，一般在需要监控 ICMP （ ping 延迟）状态时需要启用。此时使用 `blackbox_exporter-osc-0.16.0.linux-amd64.tar.gz` 包，同时修改 `blackbox.yml` 为：

```
modules:
  http_2xx:
    prober: http
  http_post_2xx:
    prober: http
    http:
      method: POST
  tcp_connect:
    prober: tcp
  pop3s_banner:
    prober: tcp
    tcp:
      query_response:
      - expect: "^+OK"
      tls: true
      tls_config:
        insecure_skip_verify: false
  ssh_banner:
    prober: tcp
    tcp:
      query_response:
      - expect: "^SSH-2.0-"
  irc_banner:
    prober: tcp
    tcp:
      query_response:
      - send: "NICK prober"
      - send: "USER prober prober prober :prober"
      - expect: "PING :([^ ]+)"
        send: "PONG ${1}"
      - expect: "^:[^ ]+ 001"
  icmp:
    prober: icmp
```

启动脚本： `start_blackbox_exporter.sh`

```
#!/bin/bash
nohup ./blackbox_exporter --config.file="./blackbox.yml" > ./blackbox_exporter.log &
```

启动命令： `cd /opt/promExporters/blackbox_exporter && bash start_blackbox_exporter.sh`

对于 sto 服务器，由于需要配置自定义监控项，所以使用 `blackbox_exporter-sto-0.16.0.linux-amd64.tar.gz` 包，该包下包含了所需的配置文件和脚本

```
blackbox.yml         # backbox_exporter 配置文件，主要注意 ruby 安装路径，默认是 /usr/local/bin/ruby ，根据实际修改
check_pid_status.sh  # 获取指定 PID 文件的进程存活状态，主要注意 gitee 安装路径，默认是 /home/git/gitee ，根据实际修改
get_worker.rb        # 获取 sidekiq 队列内任务数的 ruby 脚本，一般不需要修改
```

启动脚本和启动命令同上
