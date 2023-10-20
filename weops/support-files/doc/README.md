## 嘉为蓝鲸Elasticsearch插件使用说明

## 使用说明

### 插件功能

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

elasticsearch版本: >= 5.x
部署模式支持: 单机(Standalone), 集群(Cluster)

**是否支持远程采集:**

是

### 参数说明


| **参数名**                     | **含义**                                                 | **是否必填** | **使用举例**              |
|-----------------------------|--------------------------------------------------------|----------|-----------------------|
| ES_USERNAME                 | elasticsearch账户名, 填入则会覆盖uri中的账户, 特殊字符不需要转义             | 否        | weops                 |
| ES_PASSWORD                 | elasticsearch密码, 填入则会覆盖uri中的密码, 特殊字符不需要转义              | 否        | Weops@123             |
| --es.uri                    | elasticsearch访问地址, 注意区分http和https, uri中的账户密码特殊字符需要转义   | 是        | http://127.0.0.1:9200 |
| --es.all                    | 全节点采集开关(开关参数), 如果打开则采集集群中所有节点, 否则只采集填写的连接地址的节点数据, 默认关闭 | 是        |                       |
| --es.ssl-skip-verify        | 跳过SSL认证开关(开关参数), 如果打开则跳过SSL认证, 默认关闭                    | 是        |                       |
| --es.indices                | 索引采集开关(开关参数), 如果打开则采集所有在集群中的索引, 默认关闭                   | 否        |                       |
| --es.indices_settings       | 索引配置采集开关(开关参数), 如果打开则采集所有在集群中的索引配置信息, 默认关闭             | 否        |                       |
| --es.indices_mappings       | 索引映射采集开关(开关参数), 如果打开则采集所有在集群中的索引映射信息, 默认关闭             | 否        |                       |
| --es.shards                 | 分片采集开关(开关参数), 如果打开则采集所有在集群中的分片信息, 默认关闭                 | 否        |                       |
| --es.slm                    | 快照管理采集开关(开关参数), 如果打开则采集快照管理信息, 默认关闭                    | 否        |                       |
| --collector.clustersettings | 集群配置采集开关(开关参数), 如果打开则采集集群配置信息, 默认关闭                    | 否        |                       |
| --collector.snapshots       | 快照采集开关(开关参数), 如果打开则采集快照信息, 默认关闭                        | 否        |                       |
| --es.clusterinfo.interval   | 集群配置信息更新时间间隔，默认5m                                      | 否        | 5m                    |
| --es.timeout                | 连接elasticsearch超时时间, 默认5s                              | 否        | 5s                    |
| --web.listen-address        | exporter监听id及端口地址                                      | 否        | 127.0.0.1:9601        |
| --log.level                 | 日志级别                                                   | 否        | info                  |

### 使用指引

1. 配置监控账户
   示例：


   | 设置                | 所需权限                                                         | 描述                                                                                     |
   |-------------------|--------------------------------------------------------------|----------------------------------------------------------------------------------------|
   | exporter defaults | cluster monitor                                              | 所有集群的只读操作，如集群健康和状态、热线程、节点信息、节点和集群统计以及待处理的集群任务。                                         |
   | cluster_settings  | cluster monitor                                              |                                                                                        |
   | indices           | indices monitor                                              | 所有监控所需的操作（恢复、段信息、索引统计和状态）。 可对每个索引或 *（通配符）应用此权限。                                        |
   | indices_settings  | indices monitor                                              | 可对每个索引或 *（通配符）应用此权限。                                                                   |
   | indices_mappings  | indices view_index_metadata                                  | 可对每个索引或 *（通配符）应用此权限。                                                                   |
   | shards            | 不确定是indices、cluster monitor还是两者都是                            |                                                                                        |
   | snapshots         | cluster:admin/snapshot/status 和 cluster:admin/repository/get | [ES Forum Post](https://discuss.elastic.co/t/elasticsearch-exporter-privileges/123842) |
   | slm               | read_slm                                                     |                                                                                        |
   | data_stream       | monitor 或 manage                                             | 可对每个数据流或 *（通配符）应用此权限。                                                                  |

   不同版本的elasticsearch配置监控账户的方式和可配置权限不同，具体可参考官方文档

- [内置用户](https://www.elastic.co/guide/en/elasticsearch/reference/current/built-in-users.html)
- [定义角色](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-privileges.html#privileges-list-cluster)
- [特权](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-privileges.html)

2. 采集参数
   探针每次从 Elasticsearch 服务抓取监控指标时都会获取新的信息。
   因此，需要注意频繁的采集频率可能会对 Elasticsearch 服务造成过大的压力，
   特别是当打开了 `--es.all` 和 `--es.indices` 的采集开关。
   建议首先测量从 `/_nodes/stats` 和 `/_all/_stats` 获取数据所需的时间，然后根据实际情况来调整采集频率。

### 指标简介

### 版本日志

#### weops_elasticsearch_exporter 4.3.3

- weops调整

添加“小嘉”微信即可获取elasticsearch监控指标最佳实践礼包，其他更多问题欢迎咨询

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
