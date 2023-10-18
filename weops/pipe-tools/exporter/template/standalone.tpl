apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: es-exporter-standalone-{{VERSION}}
  namespace: elasticsearch
spec:
  serviceName: es-exporter-standalone-{{VERSION}}
  replicas: 1
  selector:
    matchLabels:
      app: es-exporter-standalone-{{VERSION}}
  template:
    metadata:
      annotations:
        telegraf.influxdata.com/interval: 1s
        telegraf.influxdata.com/inputs: |+
          [[inputs.cpu]]
            percpu = false
            totalcpu = true
            collect_cpu_time = true
            report_active = true

          [[inputs.disk]]
            ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]

          [[inputs.diskio]]

          [[inputs.kernel]]

          [[inputs.mem]]

          [[inputs.processes]]

          [[inputs.system]]
            fielddrop = ["uptime_format"]

          [[inputs.net]]
            ignore_protocol_stats = true

          [[inputs.procstat]]
          ## pattern as argument for exporter (ie, exporter -f <pattern>)
            pattern = "exporter"
        telegraf.influxdata.com/class: opentsdb
        telegraf.influxdata.com/env-fieldref-NAMESPACE: metadata.namespace
        telegraf.influxdata.com/limits-cpu: '300m'
        telegraf.influxdata.com/limits-memory: '300Mi'
      labels:
        app: es-exporter-standalone-{{VERSION}}
        exporter_object: elasticsearch
        object_mode: standalone
        object_version: {{VERSION}}
        pod_type: exporter
    spec:
      nodeSelector:
        node-role: worker
      shareProcessNamespace: true
      containers:
      - name: es-exporter-standalone-{{VERSION}}
        image: registry-svc:25000/library/elasticsearch-exporter:latest
        imagePullPolicy: Always
        securityContext:
          allowPrivilegeEscalation: false
          runAsUser: 0
        args:
          - --es.uri=http://elasticsearch-{{VERSION}}:9200
          - --es.all
          - --es.cluster_settings
          - --es.shards
          - --es.snapshots
          - --es.timeout=5s

        resources:
          requests:
            cpu: 100m
            memory: 100Mi
          limits:
            cpu: 500m
            memory: 500Mi
        ports:
        - containerPort: 9114

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: es-exporter-standalone-{{VERSION}}
  name: es-exporter-standalone-{{VERSION}}
  namespace: elasticsearch
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9114"
    prometheus.io/path: '/metrics'
spec:
  ports:
  - port: 9114
    protocol: TCP
    targetPort: 9114
  selector:
    app: es-exporter-standalone-{{VERSION}}
