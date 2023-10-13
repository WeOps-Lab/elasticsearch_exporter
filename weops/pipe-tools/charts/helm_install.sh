#!/bin/bash

# 部署监控对象
object=elasticsearch
object_versions=("8.10.3" "7.17.14" "5.6.16")

# 设置起始端口号
port=39200

for version in "${object_versions[@]}"; do
    version_suffix="v$(echo "$version" | grep -Eo '[0-9]{1,2}\.[0-9]{1,2}' | tr '.' '-')"

    helm install $object-$version_suffix --namespace $object -f ./values/bitnami_values.yaml ./$object \
    --set image.tag=$version \
    --set commonLabels.object_version=$version_suffix \
    --set service.type='NodePort' \
    --set service.nodePorts.restAPI=$port

    ((port++))
    sleep 1
done


helm install es-v6-8 --namespace elasticsearch  --version 6.8.12 \
 --set persistence.enabled=false \
 --set image=elasticsearch \
 --set imageTag=6.8.12 \
 --set service.nodePort="$port" \
 --set service.type=NodePort \
 elastic/elasticsearch