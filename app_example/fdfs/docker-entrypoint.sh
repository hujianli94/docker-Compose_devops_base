#!/bin/bash

ln -sf /data/fastdfs/storage/data /data/fastdfs/storage/data/M00
sed -i "s/myhostname/$(hostname)/g" /etc/fdfs/storage.conf
sed -i "s/myhostname/$(hostname)/g" /etc/fdfs/mod_fastdfs.conf

fdfs_trackerd /etc/fdfs/tracker.conf start
fdfs_storaged /etc/fdfs/storage.conf start

/usr/local/nginx-fdfs/sbin/nginx -g "daemon off;"
