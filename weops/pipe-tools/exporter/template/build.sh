#!/bin/bash

for version in v5-6 v7-17 v8-10; do
    # standalone
    standalone_output_file="standalone_${version}.yaml"
    sed "s/{{VERSION}}/${version}/g;" standalone.tpl > ../standalone/${standalone_output_file}
done

for version in v6-8; do
    # standalone
    standalone_output_file="standalone_${version}.yaml"
    sed "s/{{VERSION}}/${version}/g;" v6-8.tpl > ../standalone/${standalone_output_file}
done
