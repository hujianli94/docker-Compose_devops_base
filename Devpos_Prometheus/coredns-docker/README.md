## 使用 CoreDNS 作为内网 DNS 服务器

### 创建配置文件持久化目录，并复制配置文件

```
mkdir -p /data/coredns/zones
cp hosts /data/coredns/
# 以添加 zone gitee.cc 为例：
mkdir -p /data/coredns/zones/gitee.cc
cp db.gitee.cc /data/coredns/zones/gitee.cc/
cp Corefile /data/coredns/
```

### 使用 docker-compose 启动服务

```
docker-compose up -d
# host network 模式，解决 CentOS 下 bridge 网络无法被同节点其他容器连接
docker-compose -f docker-compose-host-network.yml up -d
```

## PS1: 更新 RFC 1035-style zone 文件记录

对于 `hosts` 文件的更新会在 3 秒内更新解析值

对于 `auto` 插件指定的 RFC 1035-style zone 文件的更新，[官方文档](https://coredns.io/plugins/auto/#syntax)给出： `auto` 插件会在 `reload` 指定的时间重新读取 zone 文件，并且在 Serial 值更新是重新加载 zone 文件，只修改记录而不修改 Serial 值是无法应用更新的。

## PS2: zone 文件命名规则（必须遵从）

CoreDNS 根据“域”来分发解析请求到指定配置，所以必须匹配指定的域才能获取到正确的解析。 `auto` 插件在读取 `directory` 指定的 zone 目录时会根据正则表达式解析 zone 文件名（详见[官方说明](https://coredns.io/plugins/auto/#syntax)），默认规则为： `db\.(.*) {1}` i.e. 如果文件名为 `db.example.com` ， 那么解析到的域就是 `example.com` 。

同时 `Corefile` 文件中需要为每一个自定义域新建一组配置，如 `gitee.cc` 域：

```
    auto gitee.cc {
        directory /data/zones/gitee.cc
        reload 10s
        transfer to *
    }
```
