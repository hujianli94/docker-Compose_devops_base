#!/bin/bash

show_usage="args: [-n , -c] [--name=atompi-node, --consul=consul:8500]"

name=""
consul=""

GETOPT_ARGS=`getopt -o n:c: -al name:,consul: -- "$@"`

eval set -- "$GETOPT_ARGS"

while [ -n "$1" ]
do
    case "$1" in
        -n|--name) name=$2; shift 2;;
        -c|--consul) consul=$2; shift 2;;
        --) break ;;
        *) echo $1,$2,$show_usage; break ;;
    esac
done

if [[ -z $name || -z $consul ]]; then
    echo -e $show_usage
    echo "name: $name , consul: $consul"
    exit 0
else
    curl --request PUT "http://$consul/v1/agent/service/deregister/$name"
fi
