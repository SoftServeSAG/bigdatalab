#
# Installs and configures flume agent to receive log entries
#

class profiles::flume_collector inherits profiles::linux {
    include stdlib
    include maven::maven
    include bigtop_repo
    include flume::install
    include flume::service
    Class['maven::maven'] -> Class['bigtop_repo'] -> Class['flume::install'] -> Class['flume::collector'] -> Class['flume::service']

    $deploy_cluster = hiera( 'profiles::cloudera_director_client::deploy_cluster', false )
    $clusterName = hiera( 'profiles::elasticsearch::cluster_name', 'bigdatalab' )
    $flume_collector_node = $::ipaddress
    $hadoop_namenode = hiera( 'profiles::flume_collector::hadoop_namenode', 'localhost' )
    $elasticsearch_node = hiera( 'profiles::flume_collector::elasticsearch_node', 'localhost' )

    $channels = {  access_elasticsearch_channel => { 'type' => 'memory',
                                         'capacity' => '2000',
                                         'transactionCapactiy' => '200'
                                       },
                     error_elasticsearch_channel  => { 'type' => 'memory',
                                         'capacity' => '2000',
                                         'transactionCapactiy' => '200'
                                       },
                     access_hdfs_channel => { 'type' => 'memory',
                                         'capacity' => '2000',
                                         'transactionCapactiy' => '200'
                                       },
                     error_hdfs_channel  => { 'type' => 'memory',
                                         'capacity' => '2000',
                                         'transactionCapactiy' => '200'
                                       }
                  }
                     # Describe/configure Avro source for access log
    $sources  = {  access_avro_source  => { 'type' => 'avro',
                                              'bind' => $flume_collector_node,
                                              'port' => '4545',
                                               # ----------- Log event parser -------------
                                               # Apache access log parser
                                               # Sample: 143.21.52.246 - - [19/Jun/2014:12:15:17 +0000] "GET /test.html HTTP/1.1" 200 341 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:6.0a1) Gecko/20110421 Firefox/6.0a1"
                                               # regexp for default access log line
                                              'interceptors.access_interceptor.type' => 'regex_extractor',
                                              'interceptors.access_interceptor.regex' => '^([\\d.]+) (\\S+) (\\S+) \\[([\\w:/]+\\s[+\\-]\\d{4})\\] \"(\\S+) (\\S+) (\\S+)\" (\\d{3}) (\\d+) (\\d+) \"([^\"]+)\" \"([^\"]+)\"',
                                              'interceptors.access_interceptor.serializers' => 'sa1 sa2 sa3 sa4 sa5 sa6 sa7 sa8 sa9 sa10 sa11 sa12',
                                              'interceptors.access_interceptor.serializers.sa1.name' => 'client_ip',
                                              'interceptors.access_interceptor.serializers.sa2.name' => 'identd',
                                              'interceptors.access_interceptor.serializers.sa3.name' => 'userid',
                                              'interceptors.access_interceptor.serializers.sa4.type' => 'org.apache.flume.interceptor.RegexExtractorInterceptorMillisSerializer',
                                              'interceptors.access_interceptor.serializers.sa4.name' => 'event_timestamp',
                                              'interceptors.access_interceptor.serializers.sa4.pattern' => 'dd/MMM/yyyy:HH:mm:ss Z',
                                              'interceptors.access_interceptor.serializers.sa5.name' => 'request_method',
                                              'interceptors.access_interceptor.serializers.sa6.name' => 'request_url',
                                              'interceptors.access_interceptor.serializers.sa7.name' => 'request_protocol',
                                              'interceptors.access_interceptor.serializers.sa8.name' => 'response_code',
                                              'interceptors.access_interceptor.serializers.sa9.name' => 'response_size',
                                              'interceptors.access_interceptor.serializers.sa10.name' => 'request_time',
                                              'interceptors.access_interceptor.serializers.sa11.name' => 'referrer',
                                              'interceptors.access_interceptor.serializers.sa12.name' => 'user_agent',
                                              'interceptors.host_interceptor.type' => 'org.apache.flume.interceptor.HostInterceptor$Builder',
                                              'interceptors.host_interceptor.hostHeader' => 'server_host',
                                              'interceptors.ts_interceptor.type' => 'timestamp',
                                              'interceptors.geoip_interceptor.type' => 'com.softserveinc.sag.flume.interceptors.GeoIpInterceptor$Builder',
                                              'interceptors.geoip_interceptor.max_mind_db_file_name' => '/usr/share/GeoIP/GeoLiteCity.dat',
                                              'interceptors.geoip_interceptor.ip_field_name' => 'client_ip',
                                              'interceptors' => 'access_interceptor ts_interceptor host_interceptor geoip_interceptor',
                                              'channels' => 'access_hdfs_channel access_elasticsearch_channel'
                                            },
                     # Describe/configure Avro source for error log
                     error_avro_source   => { 'type' => 'avro',
                                              'bind' => $flume_collector_node,
                                              'port' => '4546',
                                              # Apache error log parser
                                              # Sample: [19/Jun/2014:14:23:15 +0000] [error] [client 50.83.180.156] Directory index forbidden by rule: /home/httpd/ 
                                              'interceptors.error_interceptor.type' => 'regex_extractor',
                                              'interceptors.error_interceptor.regex' => '\\[([\\w:/]+\\s[+\\-]\\d{4})\\] \\[(.+?)\\] \\[client ([\\d.]+)\\] (.*)',
                                              'interceptors.error_interceptor.serializers' => 'se1 se2 se3 se4',
                                              'interceptors.error_interceptor.serializers.se1.type' => 'org.apache.flume.interceptor.RegexExtractorInterceptorMillisSerializer',
                                              'interceptors.error_interceptor.serializers.se1.name' => 'event_timestamp',
                                              'interceptors.error_interceptor.serializers.se1.pattern' => 'dd/MMM/yyyy:HH:mm:ss Z',
                                              'interceptors.error_interceptor.serializers.se2.name' => 'level',
                                              'interceptors.error_interceptor.serializers.se3.name' => 'client_ip',
                                              'interceptors.error_interceptor.serializers.se4.name' => 'message',
                                              'interceptors.host_interceptor.type' => 'org.apache.flume.interceptor.HostInterceptor$Builder',
                                              'interceptors.host_interceptor.hostHeader' => 'server_host',
                                              'interceptors.ts_interceptor.type' => 'timestamp',
                                              'interceptors.geoip_interceptor.type' => 'com.softserveinc.sag.flume.interceptors.GeoIpInterceptor$Builder',
                                              'interceptors.geoip_interceptor.max_mind_db_file_name' => '/usr/share/GeoIP/GeoLiteCity.dat',
                                              'interceptors.geoip_interceptor.ip_field_name' => 'client_ip',
                                              'interceptors' => 'error_interceptor ts_interceptor host_interceptor geoip_interceptor',
                                              'channels' => 'error_elasticsearch_channel error_hdfs_channel'
                                            },

                  }
                     # ElasticSearch sink for Apache access log
    $sinks    = {  access_elasticsearch_sink => { 'type' => 'org.apache.flume.sink.elasticsearch.ElasticSearchSink',
                                                    'batchSize' => '50',
                                                    'hostNames' => "${elasticsearch_node}:9300",
                                                    'indexName' => 'apache-logs',
                                                    'clusterName' => "${clusterName}",
                                                    'indexType' => 'access',
                                                    'serializer' => 'org.apache.flume.sink.elasticsearch.ElasticSearchLogStashEventSerializer',
                                                    'channel' => 'access_elasticsearch_channel'
                                                  },
                     # ElasticSearch sink for Apache error log
                     error_elasticsearch_sink  => { 'type' => 'org.apache.flume.sink.elasticsearch.ElasticSearchSink',
                                                    'batchSize' => '50',
                                                    'hostNames' => "${elasticsearch_node}:9300",
                                                    'indexName' => 'apache-logs',
                                                    'clusterName' => "${clusterName}",
                                                    'indexType' => 'error',
                                                    'serializer' => 'org.apache.flume.sink.elasticsearch.ElasticSearchLogStashEventSerializer',
                                                    'channel' => 'error_elasticsearch_channel'
                                                  },
                     # HDFS sink for access log
                     access_hdfs_sink          => { 'type' => 'hdfs',
                                                    'hdfs.path' => "hdfs://${hadoop_namenode}:8020/flume/logs/access/%y-%m-%d/%H%M",
                                                    'hdfs.fileType' => 'DataStream',
                                                    'hdfs.filePrefix' => 'access-',
                                                    'hdfs.fileSuffix' => '.avro',
                                                    'hdfs.round' => true,
                                                    'hdfs.roundValue' => '10',
                                                    'hdfs.roundUnit' => 'minute',
                                                    'hdfs.batchSize' => '100',
                                                    'hdfs.rollInterval' => '30',
                                                    'hdfs.rollCount' => '0',
                                                    'hdfs.rollSize' => '0',
                                                    'hdfs.idleTimeout' => '60',
                                                    'hdfs.callTimeout' => '25000',
                                                    'serializer' => 'avro_event',
                                                    'serializer.compressionCodec' => 'snappy',
                                                    'channel' => 'access_hdfs_channel'
                                                  },
                     # HDFS sink for error log
                     error_hdfs_sink           => { 'type' => 'hdfs',
                                                    'hdfs.path' => "hdfs://${hadoop_namenode}:8020/flume/logs/error/%y-%m-%d/%H%M",
                                                    'hdfs.fileType' => 'DataStream',
                                                    'hdfs.filePrefix' => 'error-',
                                                    'hdfs.fileSuffix' => '.avro',
                                                    'hdfs.round' => true,
                                                    'hdfs.roundValue' => '10',
                                                    'hdfs.roundUnit' => 'minute',
                                                    'hdfs.batchSize' => '100',
                                                    'hdfs.rollInterval' => '30',
                                                    'hdfs.rollCount' => '0',
                                                    'hdfs.rollSize' => '0',
                                                    'hdfs.idleTimeout' => '60',
                                                    'hdfs.callTimeout' => '25000',
                                                    'serializer' => 'avro_event',
                                                    'serializer.compressionCodec' => 'snappy',
                                                    'channel' => 'error_hdfs_channel'
                                                  }
                  }

    validate_hash($channels)
    validate_hash($sources)
    validate_hash($sinks)


    if $deploy_cluster {
      notice('Deploying Flume configuration for CDH')
      $channel = $channels
      $source  = $sources
      $sink    = $sinks
    }
    else {
      $channel = delete($channels, ['access_hdfs_channel', 'error_hdfs_channel'])
      $source  = $sources
      $sink    = delete($sinks, ['access_hdfs_sink', 'error_hdfs_sink'])
    }

    class {'flume::collector':
      channels => $channel,
      sources  => $source,
      sinks    => $sink
    }
}
