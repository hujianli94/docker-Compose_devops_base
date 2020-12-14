# gitlab-docker-compose-installer

## 项目介绍
使用docker-compose安装gitlab。
包含中文版twang2218/gitlab-ce-zh:11.1.4和英文版sameersbn/gitlab:latest。

## 软件架构
中文版：./docker-gitlab-zh
英文版：./docker-gitlab


## 安装教程

1. 安装docker-ce
2. 安装docker-compose
3. 上传文件到服务器目录如：/data/src/gitlab-docker-compose-installer
4. 安装中文版
    ```
    $ cd /data/src/gitlab-docker-compose-installer
    $ cd docker-gitlab-zh
    $ docker-compose up -d
    ```
5. 安装英文版
    ```
    $ cd /data/src/gitlab-docker-compose-installer
    $ cd docker-gitlab
    $ docker-compose up -d
    ```
## 使用说明

1. 中文gitlab访问地址：http://[host]:11080/
2. 英文gitlab访问地址：http://[host]:10080/

## 鸣谢
中文版贡献者：
Tao Wang
https://github.com/twang2218/gitlab-ce-zh

英文版贡献者：
Niclas Mietz (solidnerd)，Sameer Naik (sameersbn)
https://github.com/sameersbn/docker-gitlab