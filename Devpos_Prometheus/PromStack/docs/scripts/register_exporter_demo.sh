# without metadata
bash register_exporter.sh --id=$(hostname)-node --name=$(hostname)-node --address=$(hostname) --port=9101 --tags='"node_exporter"' --consul=192.168.2.58:8500
bash register_exporter.sh --id=$(hostname)-nginx --name=$(hostname)-nginx --address=$(hostname) --port=9103 --tags='"nginx_exporter"' --consul=192.168.2.58:8500
bash register_exporter.sh --id=$(hostname)-redis --name=$(hostname)-redis --address=$(hostname) --port=9121 --tags='"redis_exporter"' --consul=192.168.2.58:8500

# with metadata
bash register_exporter_with_metadata.sh --id=$(hostname)-blackbox --name=$(hostname)-blackbox --address=$(hostname) --port=9115 --tags='"blackbox_exporter"' --consul=192.168.2.58:8500 --meta='"meta":{"module":"http_2xx","target":"https://baidu.com"}'
