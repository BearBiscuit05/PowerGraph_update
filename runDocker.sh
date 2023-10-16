#!/bin/bash
set -e
# 参数设置
cluster_size=32
base_hostname="PGcluster_"
network_name="pg-network"
start_ip="43.0.0."  # 起始IP地址i
image_name="pgimage:v3"
beg_ip=8

# 创建 Docker 网络

for i in $(seq 1 "$cluster_size"); do
    hostname="$base_hostname$i"
    ip_octet=$(($beg_ip+i))
    ip="$start_ip$ip_octet"
    custom_hosts_params+=" --add-host $hostname:$ip"
done

# 循环创建集群容器

for i in $(seq 1 "$cluster_size"); do
    hostname="$base_hostname$i"
    ip_octet=$(($beg_ip+i))
    ip="$start_ip$ip_octet"

    if docker ps -a | grep -q "$hostname"; then
        echo "Container '$hostname' exists."
        docker stop $hostname
        docker rm $hostname
    fi

   # 创建容器，并指定主机名和自定义主机映射
    docker run -d -it --name "$hostname" --ulimit nofile=65535 --hostname "$hostname" -v /raid/bear/dockerfile:/data -v /home/bear/workspace/PowerGraph:/PowerGraph --net $network_name --ip $ip $image_name /bin/bash -c "service ssh restart && /bin/bash"
    echo "Container pg_$i created with hostname $hostname with IP:$ip"
done

