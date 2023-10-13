#!/bin/bash

# 部署监控对象
object=elasticsearch
object_versions=("8.10.3" "7.17.14" "6.8.23" "5.6.16" "2.4.4-r2")

# 设置起始端口号
port=39200

for version in "${object_versions[@]}"; do
    version_suffix="v$(echo "$version" | grep -Eo '[0-9]{1,2}\.[0-9]{1,2}' | tr '.' '-')"

    helm install $object-standalone-$version_suffix --namespace $object -f ./values/bitnami_values.yaml ./$object \
    --set image.tag=$version \
    --set commonLabels.object_version=$version_suffix \
    --set service.type='NodePort' \
    --set service.nodePorts.restAPI=$port

    ((port++))
    sleep 1
done

