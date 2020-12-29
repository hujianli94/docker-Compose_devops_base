FROM debian:stretch

MAINTAINER atompi <coder.atompi@gmail.com>

COPY sources.list /etc/apt/sources.list
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        gcc \
        make \
        libpcre3 \
        libpcre3-dev \
        openssl \
        libssl-dev \
        zlib1g-dev \
    && apt-get -y autoremove --purge \
    && rm -rf /var/lib/apt/lists/*

ADD libfastcommon-1.0.43.tar.gz /tmp/
RUN cd /tmp/libfastcommon-1.0.43 \
    && ./make.sh \
    && ./make.sh install \
    && cd ../ && rm -rf /tmp/libfastcommon-1.0.43

ADD fastdfs-5.12.tar.gz /tmp/
RUN cd /tmp/fastdfs-5.12 \
    && ./make.sh \
    && ./make.sh install \
    && cd ../ && rm -rf /tmp/fastdfs-5.12

ADD fastdfs-nginx-module-1.20.tar.gz /tmp/
ADD nginx-1.16.1.tar.gz /tmp/
RUN cd /tmp/nginx-1.16.1 \
    && ./configure --prefix=/usr/local/nginx-fdfs --with-http_gzip_static_module --with-http_ssl_module --with-http_v2_module --with-http_stub_status_module --with-http_realip_module --with-file-aio --with-threads --with-stream --with-stream_ssl_preread_module --with-stream_ssl_module --with-stream_realip_module --add-module=/tmp/fastdfs-nginx-module-1.20/src \
    && make \
    && make install \
    && cd ../ && rm -rf /tmp/nginx-1.16.1 && rm -rf /tmp/fastdfs-nginx-module-1.20 \
    && mkdir -p /data/fastdfs/tracker/data /data/fastdfs/storage/data
ADD fdfs-conf.tar.gz /etc/fdfs/
COPY nginx.conf /usr/local/nginx-fdfs/conf/

COPY docker-entrypoint.sh /

VOLUME /data/fastdfs/tracker/data
VOLUME /data/fastdfs/storage/data
EXPOSE 80 443 22122 23000

ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]
