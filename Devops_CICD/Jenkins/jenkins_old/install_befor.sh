#!/usr/bin/env sh
[ -d /data/jenkins/ ] || mkdir -p /data/jenkins/


#-------------- jenkins_jian 登录密码 ------------------------------------
#cat /var/jenkins_home/secrets/initialAdminPassword
#57d5a725c24e495084661ba073360824

# 对应
#[root@localhost jenkins_jian]# cat /data/jenkins_jian/secrets/initialAdminPassword
#9fdb4172b14649aea37260a75ae00adf

# 或者
#[root@localhost jenkins_jian]# docker exec docker_id cat /var/jenkins_home/secrets/initialAdminPassword
#9fdb4172b14649aea37260a75ae00adf

