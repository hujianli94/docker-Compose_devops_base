#!/bin/bash

show_usage="args: [-i , -n , -a , -p, -t, -c, m]\n[--id=atompi_node, --name=atompi_node, --address=atompi, --port=9100, --tags='\"node_exporter\"', --consul=consul:8500, --meta='\"meta\":{\"module\":\"http_2xx\",\"target\":\"https://baidu.com\"}']"

id=""
name=""
address=""
port=""
tags=""
consul=""
meta=""

GETOPT_ARGS=`getopt -o i:n:a:p:t:c:m: -al id:,name:,address:,port:,tags:,consul:,meta: -- "$@"`

eval set -- "$GETOPT_ARGS"

while [ -n "$1" ]
do
    case "$1" in
        -i|--id) id=$2; shift 2;;
        -n|--name) name=$2; shift 2;;
        -a|--address) address=$2; shift 2;;
        -p|--port) port=$2; shift 2;;
        -t|--tags) tags=$2; shift 2;;
        -c|--consul) consul=$2; shift 2;;
        -m|--meta) meta=$2; shift 2;;
        --) break ;;
        *) echo $1,$2,$show_usage; break ;;
    esac
done

if [[ -z $id || -z $name || -z $address || -z $port || -z $tags || -z $consul ]]; then
    echo -e $show_usage
    echo "id: $id , name: $name , address: $address , port: $port , tags: $tags , consul: $consul , meta: $meta"
    exit 0
else
    curl -X PUT -d '{"id": "'"$id"'","name": "'"$name"'","address": "'"$address"'","port": '"$port"',"tags": ['"$tags"'],"checks": [{"http": "http://'"$address"':'"$port"'/","interval": "5s"}],'"$meta"'}' "http://$consul/v1/agent/service/register"
fi
