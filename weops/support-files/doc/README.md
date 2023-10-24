## 嘉为蓝鲸Elasticsearch插件使用说明

## 使用说明

### 插件功能

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

elasticsearch版本: 5.x, 6.x, 7.x, 8.x
部署模式支持: 单机(Standalone), 集群(Cluster)

**是否支持远程采集:**

是

### 参数说明


| **参数名**                  | **含义**                                                                                             | **是否必填** | **使用举例**          |
| --------------------------- | ---------------------------------------------------------------------------------------------------- | ------------ | --------------------- |
| ES_USERNAME                 | elasticsearch账户名, 填入则会覆盖uri中的账户, 特殊字符不需要转义                                     | 否           | weops                 |
| ES_PASSWORD                 | elasticsearch密码, 填入则会覆盖uri中的密码, 特殊字符不需要转义                                       | 否           | Weops@123             |
| --es.uri                    | elasticsearch访问地址, 注意区分http和https, uri中的账户密码特殊字符需要转义                          | 是           | http://127.0.0.1:9200 |
| --es.all                    | 全节点采集开关(开关参数), 如果打开则采集集群中所有节点, 否则只采集填写的连接地址的节点数据, 默认关闭 | 是           |                       |
| --es.ssl-skip-verify        | 跳过SSL认证开关(开关参数), 如果打开则跳过SSL认证, 默认关闭                                           | 是           |                       |
| --es.indices                | 索引采集开关(开关参数), 如果打开则采集所有在集群中的索引, 默认关闭                                   | 否           |                       |
| --es.indices_settings       | 索引配置采集开关(开关参数), 如果打开则采集所有在集群中的索引配置信息, 默认关闭                       | 否           |                       |
| --es.indices_mappings       | 索引映射采集开关(开关参数), 如果打开则采集所有在集群中的索引映射信息, 默认关闭                       | 否           |                       |
| --es.shards                 | 分片采集开关(开关参数), 如果打开则采集所有在集群中的分片信息, 默认关闭                               | 否           |                       |
| --es.slm                    | 快照管理采集开关(开关参数), 如果打开则采集快照管理信息, 默认关闭                                     | 否           |                       |
| --collector.clustersettings | 集群配置采集开关(开关参数), 如果打开则采集集群配置信息, 默认关闭                                     | 否           |                       |
| --collector.snapshots       | 快照采集开关(开关参数), 如果打开则采集快照信息, 默认关闭                                             | 否           |                       |
| --es.clusterinfo.interval   | 集群配置信息更新时间间隔，默认5m                                                                     | 否           | 5m                    |
| --es.timeout                | 连接elasticsearch超时时间, 默认5s                                                                    | 否           | 5s                    |
| --web.listen-address        | exporter监听id及端口地址                                                                             | 否           | 127.0.0.1:9601        |
| --log.level                 | 日志级别                                                                                             | 否           | info                  |

### 使用指引

1. 配置监控账户
   示例：


   | 设置              | 所需权限                                                      | 描述                                                                                         |
   | ----------------- | ------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
   | exporter defaults | cluster monitor                                               | 所有集群的只读操作，如集群健康和状态、热线程、节点信息、节点和集群统计以及待处理的集群任务。 |
   | cluster_settings  | cluster monitor                                               |                                                                                              |
   | indices           | indices monitor                                               | 所有监控所需的操作（恢复、段信息、索引统计和状态）。 可对每个索引或 *（通配符）应用此权限。  |
   | indices_settings  | indices monitor                                               | 可对每个索引或 *（通配符）应用此权限。                                                       |
   | indices_mappings  | indices view_index_metadata                                   | 可对每个索引或 *（通配符）应用此权限。                                                       |
   | shards            | 不确定是indices、cluster monitor还是两者都是                  |                                                                                              |
   | snapshots         | cluster:admin/snapshot/status 和 cluster:admin/repository/get | [ES Forum Post](https://discuss.elastic.co/t/elasticsearch-exporter-privileges/123842)       |
   | slm               | read_slm                                                      |                                                                                              |
   | data_stream       | monitor 或 manage                                             | 可对每个数据流或 *（通配符）应用此权限。                                                     |

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


| **指标ID**                                                           | **指标中文名**                                  | **维度ID**                              | **维度含义**                                   | **单位**  |
| -------------------------------------------------------------------- | ----------------------------------------------- | --------------------------------------- | ---------------------------------------------- | --------- |
| elasticsearch_clusterinfo_up                                         | Elasticsearch集群信息收集器的运行状态           | url                                     | 请求地址                                       | -         |
| elasticsearch_clusterinfo_version_info                               | Elasticsearch版本信息                           | cluster, version                        | 集群名称, 版本                                 | -         |
| elasticsearch_cluster_health_number_of_nodes                         | Elasticsearch节点数量                           | -                                       | -                                              | -         |
| elasticsearch_cluster_health_up                                      | Elasticsearch集群健康采集器状态                 | -                                       | -                                              | -         |
| elasticsearch_node_stats_up                                          | Elasticsearch节点采集器状态                     | -                                       | -                                              | -         |
| elasticsearch_index_stats_up                                         | Elasticsearch索引采集器状态                     | -                                       | -                                              | -         |
| elasticsearch_slm_stats_up                                           | Elasticsearch SLM收集器运行状态                 | -                                       | -                                              | -         |
| elasticsearch_data_stream_stats_up                                   | Elasticsearch 数据流收集器运行状态              | -                                       | -                                              | -         |
| elasticsearch_indices_mappings_stats_up                              | Elasticsearch映射抓取是否成功                   | -                                       | -                                              | -         |
| elasticsearch_nodes_roles                                            | Elasticsearch节点角色                           | cluster, host, node_name, role          | 集群名称, 主机名称, 节点名称, 节点角色         | -         |
| elasticsearch_breakers_estimated_size_bytes                          | Elasticsearch中断器估计大小                     | breaker, cluster, host                  | 中断器名称, 集群名称, 主机名称                 | bytes     |
| elasticsearch_breakers_limit_size_bytes                              | Elasticsearch中断器限制大小                     | breaker, cluster, host                  | 中断器名称, 集群名称, 主机名称                 | bytes     |
| elasticsearch_breakers_tripped                                       | Elasticsearch中断器触发数量                     | breaker, cluster, host                  | 中断器名称, 集群名称, 主机名称                 | -         |
| elasticsearch_cluster_health_active_primary_shards                   | Elasticsearch集群健康活动主要分片数             | cluster                                 | 集群名称                                       | -         |
| elasticsearch_cluster_health_active_shards                           | Elasticsearch集群健康活动分片数                 | cluster                                 | 集群名称                                       | -         |
| elasticsearch_cluster_health_delayed_unassigned_shards               | Elasticsearch延迟未分配的分片数                 | cluster                                 | 集群名称                                       | -         |
| elasticsearch_cluster_health_initializing_shards                     | Elasticsearch初始化中的分片数                   | cluster                                 | 集群名称                                       | -         |
| elasticsearch_cluster_health_number_of_data_nodes                    | Elasticsearch数据节点数量                       | cluster                                 | 集群名称                                       | -         |
| elasticsearch_cluster_health_number_of_in_flight_fetch               | Elasticsearch进行中的获取请求数量               | cluster                                 | 集群名称                                       | -         |
| elasticsearch_cluster_health_number_of_pending_tasks                 | Elasticsearch待处理任务数量                     | cluster                                 | 集群名称                                       | -         |
| elasticsearch_cluster_health_task_max_waiting_in_queue_millis        | Elasticsearch队列中的最大等待时间               | cluster                                 | 集群名称                                       | ms        |
| elasticsearch_cluster_health_relocating_shards                       | Elasticsearch正在迁移的分片数                   | cluster                                 | 集群名称                                       | -         |
| elasticsearch_cluster_health_status                                  | Elasticsearch集群健康状态                       | cluster, color                          | 集群名称, 颜色                                 | -         |
| elasticsearch_cluster_health_unassigned_shards                       | Elasticsearch未分配分片数量                     | cluster                                 | 集群名称                                       | -         |
| elasticsearch_clustersettings_stats_max_shards_per_node              | Elasticsearch节点最大分片数                     | -                                       | -                                              | -         |
| elasticsearch_clustersettings_allocation_threshold_enabled           | Elasticsearch分配决策启用状态                   | -                                       | -                                              | -         |
| elasticsearch_clustersettings_allocation_watermark_flood_stage_ratio | Elasticsearch磁盘水位阈值比例                   | -                                       | -                                              | -         |
| elasticsearch_clustersettings_allocation_watermark_high_ratio        | Elasticsearch磁盘高水位比例                     | -                                       | -                                              | -         |
| elasticsearch_clustersettings_allocation_watermark_low_ratio         | Elasticsearch磁盘低水位比例                     | -                                       | -                                              | -         |
| elasticsearch_filesystem_data_available_bytes                        | Elasticsearch可用空间字节数                     | cluster, host, mount, node_name, path   | 集群名称, 主机名称, 挂载点, 节点名称, 挂载路径 | bytes     |
| elasticsearch_filesystem_data_free_bytes                             | Elasticsearch空闲空间字节数                     | cluster, host, mount, node_name, path   | 集群名称, 主机名称, 挂载点, 节点名称, 挂载路径 | bytes     |
| elasticsearch_filesystem_data_size_bytes                             | Elasticsearch设备大小字节数                     | cluster, host, mount, node_name, path   | 集群名称, 主机名称, 挂载点, 节点名称, 挂载路径 | bytes     |
| elasticsearch_filesystem_io_stats_device_operations_count            | Elasticsearch磁盘操作计数                       | cluster, device, host, node_name        | 集群名称, 设备名称, 挂载点, 挂载路径           | -         |
| elasticsearch_filesystem_io_stats_device_read_operations_count       | Elasticsearch读操作计数                         | cluster, device, host, node_name        | 集群名称, 设备名称, 挂载点, 挂载路径           | -         |
| elasticsearch_filesystem_io_stats_device_write_operations_count      | Elasticsearch写操作计数                         | cluster, device, host, node_name        | 集群名称, 设备名称, 挂载点, 挂载路径           | -         |
| elasticsearch_filesystem_io_stats_device_read_size_kilobytes_sum     | Elasticsearch总读取的千字节数                   | cluster, device, host, node_name        | 集群名称, 设备名称, 挂载点, 挂载路径           | kilobytes |
| elasticsearch_filesystem_io_stats_device_write_size_kilobytes_sum    | Elasticsearch总写入的千字节数                   | cluster, device, host, node_name        | 集群名称, 设备名称, 挂载点, 挂载路径           | kilobytes |
| elasticsearch_indices_docs                                           | Elasticsearch文档数量                           | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_docs_deleted                                   | Elasticsearch删除文档数量                       | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_deleted_docs_primary                           | Elasticsearch仅主要分片的删除文档数量           | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_docs_primary                                   | Elasticsearch仅主要分片的文档数量               | cluster, index                          | 集群名称, 索引名称                             | -         |
| elasticsearch_indices_docs_total                                     | Elasticsearch所有分片的文档数量                 | cluster, index                          | 集群名称, 索引名称                             | -         |
| elasticsearch_indices_fielddata_evictions                            | Elasticsearch字段数据缓存驱逐次数               | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_fielddata_memory_size_bytes                    | Elasticsearch字段数据缓存内存使用字节数         | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | bytes     |
| elasticsearch_indices_filter_cache_evictions                         | Elasticsearch过滤缓存驱逐次数                   | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_filter_cache_memory_size_bytes                 | Elasticsearch过滤缓存内存使用字节数             | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | bytes     |
| elasticsearch_indices_flush_time_seconds                             | Elasticsearch索引刷新总时长                     | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_flush_total                                    | Elasticsearch索引刷新总数                       | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_get_exists_time_seconds                        | Elasticsearch索引get exists总时长               | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_get_exists_total                               | Elasticsearch索引get exists总数                 | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_get_missing_time_seconds                       | Elasticsearch索引get missing总时长              | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_get_missing_total                              | Elasticsearch索引get missing总数                | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_get_time_seconds                               | Elasticsearch索引get总时间                      | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_get_total                                      | Elasticsearch索引get总数                        | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_indexing_delete_time_seconds_total             | Elasticsearch索引删除总时间                     | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_indexing_delete_total                          | Elasticsearch索引删除总数                       | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_indexing_index_time_seconds_total              | Elasticsearch索引总时间                         | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_indexing_index_total                           | Elasticsearch索引总数                           | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_mappings_stats_json_parse_failures_total       | ElasticsearchJSON解析错误总数                   | -                                       | -                                              | -         |
| elasticsearch_indices_mappings_stats_scrapes_total                   | Elasticsearch映射抓取总数                       | -                                       | -                                              | -         |
| elasticsearch_indices_merges_docs_total                              | Elasticsearch文档合并总数                       | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_merges_total                                   | Elasticsearch合并总数                           | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_merges_total_size_bytes_total                  | Elasticsearch合并总大小                         | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | bytes     |
| elasticsearch_indices_merges_total_time_seconds_total                | Elasticsearch合并总时间                         | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_query_cache_cache_total                        | Elasticsearch查询缓存总数                       | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_query_cache_cache_size                         | Elasticsearch查询缓存大小                       | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_query_cache_count                              | Elasticsearch查询缓存命中与未命中次数           | cache, cluster, host, node_name         | 缓存动作, 集群名称, 主机名称, 节点名称         | -         |
| elasticsearch_indices_query_cache_evictions                          | Elasticsearch查询缓存驱逐次数                   | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_query_cache_memory_size_bytes                  | Elasticsearch查询缓存内存使用字节数             | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | bytes     |
| elasticsearch_indices_query_cache_total                              | Elasticsearch查询缓存总大小                     | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_refresh_time_seconds_total                     | Elasticsearch刷新总时间                         | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_refresh_total                                  | Elasticsearch刷新总数                           | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_request_cache_count                            | Elasticsearch请求缓存命中与未命中次数           | cache, cluster, host, node_name         | 缓存动作, 集群名称, 主机名称, 节点名称         | -         |
| elasticsearch_indices_request_cache_evictions                        | Elasticsearch请求缓存驱逐次数                   | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_request_cache_memory_size_bytes                | Elasticsearch请求缓存内存使用字节数             | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | bytes     |
| elasticsearch_indices_search_fetch_time_seconds                      | Elasticsearch搜索提取总时间                     | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_search_fetch_total                             | Elasticsearch搜索提取总数                       | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_search_query_time_seconds                      | Elasticsearch搜索查询总时间                     | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_search_query_total                             | Elasticsearch搜索查询总数                       | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_segments_count                                 | Elasticsearch索引分段数                         | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_segments_memory_bytes                          | Elasticsearch分段内存大小                       | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | bytes     |
| elasticsearch_indices_settings_stats_read_only_indices               | Elasticsearch允许只读索引数                     | -                                       | -                                              | -         |
| elasticsearch_indices_shards_docs                                    | Elasticsearch分片中的文档数                     | cluster, index, node, primary, shard_id | 集群名称, 索引名称, 节点ID, 主分片, 分片ID     | -         |
| elasticsearch_indices_shards_docs_deleted                            | Elasticsearch分片中的已删除文档数               | cluster, index, node, primary, shard_id | 集群名称, 索引名称, 节点ID, 主分片, 分片ID     | -         |
| elasticsearch_indices_store_size_bytes                               | Elasticsearch存储索引数据大小                   | cluster, host, node_name                | 集群名称, 索引名称                             | bytes     |
| elasticsearch_indices_store_size_bytes_primary                       | Elasticsearch主分片上的存储索引数据大小         | cluster, index                          | 集群名称, 索引名称                             | bytes     |
| elasticsearch_indices_store_size_bytes_total                         | Elasticsearch所有分片上的存储索引数据大小       | cluster, index                          | 集群名称, 索引名称                             | bytes     |
| elasticsearch_indices_store_throttle_time_seconds_total              | Elasticsearch索引存储限速时间                   | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_translog_operations                            | Elasticsearch事务日志操作总数                   | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_indices_translog_size_in_bytes                         | Elasticsearch事务日志大小                       | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | bytes     |
| elasticsearch_indices_warmer_time_seconds_total                      | Elasticsearch预热操作总时间                     | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | s         |
| elasticsearch_indices_warmer_total                                   | Elasticsearch预热操作总数                       | cluster, host, node_name                | 集群名称, 主机名称, 节点名称                   | -         |
| elasticsearch_slm_stats_total_scrapes                                | Elasticsearch SLM收集器的总抓取次数             | -                                       | -                                              | -         |
| elasticsearch_slm_stats_json_parse_failures                          | Elasticsearch SLM收集器的JSON解析失败数         | -                                       | -                                              | -         |
| elasticsearch_slm_stats_retention_runs_total                         | Elasticsearch保留运行总数                       | -                                       | -                                              | -         |
| elasticsearch_slm_stats_retention_failed_total                       | Elasticsearch保留策略失败总数                   | -                                       | -                                              | -         |
| elasticsearch_slm_stats_retention_timed_out_total                    | Elasticsearch保留策略超时总数                   | -                                       | -                                              | -         |
| elasticsearch_slm_stats_total_snapshots_taken_total                  | Elasticsearch总快照数                           | -                                       | -                                              | -         |
| elasticsearch_slm_stats_total_snapshots_failed_total                 | Elasticsearch快照失败总数                       | -                                       | -                                              | -         |
| elasticsearch_slm_stats_total_snapshots_deleted_total                | Elasticsearch快照删除总数                       | -                                       | -                                              | -         |
| elasticsearch_slm_stats_operation_mode                               | Elasticsearch SLM操作模式                       | operation_mode                          | 操作模式                                       | -         |
| elasticsearch_data_stream_stats_total_scrapes                        | Elasticsearch Data Stream统计总抓取次数         | -                                       | -                                              | -         |
| elasticsearch_data_stream_stats_json_parse_failures                  | Elasticsearch Data Stream统计的JSON解析失败次数 | -                                       | -                                              | -         |

### 版本日志

#### weops_elasticsearch_exporter 4.3.3

- weops调整

添加“小嘉”微信即可获取elasticsearch监控指标最佳实践礼包，其他更多问题欢迎咨询

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
