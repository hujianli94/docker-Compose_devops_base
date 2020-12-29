FROM alpine:latest
MAINTAINER atompi <coder.atompi@gmail.com>

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache --update --verbose \
        nfs-utils \
        bash \
        iproute2 \
    && rm -rf /var/cache/apk /tmp /sbin/halt /sbin/poweroff /sbin/reboot \
    && mkdir -p /var/lib/nfs/rpc_pipefs /var/lib/nfs/v4recovery \
    && echo "rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs defaults 0 0" >> /etc/fstab \
    && echo "nfsd       /proc/fs/nfsd           nfsd       defaults 0 0" >> /etc/fstab

COPY exports /etc/
COPY nfsd.sh /usr/bin/nfsd.sh

RUN chmod +x /usr/bin/nfsd.sh

EXPOSE 2049

ENTRYPOINT ["/usr/bin/nfsd.sh"]
