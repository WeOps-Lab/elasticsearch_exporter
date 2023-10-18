#
# build container
#
FROM --platform=linux/amd64 golang:1.19-alpine as builder
WORKDIR /

COPY elasticsearch_exporter_linux_amd64 /elasticsearch_exporter_linux_amd64

RUN chmod +x /elasticsearch_exporter_linux_amd64

EXPOSE     9308
ENTRYPOINT [ "/elasticsearch_exporter_linux_amd64" ]
