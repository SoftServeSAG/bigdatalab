#
# Installs and configures flume agent to receive log entries
#

class profiles::flume_agent inherits profiles::linux {
    include bigtop_repo
    Class['bigtop_repo'] -> Class['flume::agent']

    $flume_agent_node   = $::ipaddress
    $flume_collector_node = hiera( 'profiles::flume_agent::flume_collector_node', 'localhost' )

    class {'flume::agent':
                     # Use a channel which buffers events in memory
      channels => {  access_channel => { 'type' => 'memory',
                                         'capacity' => '1000'
                                       },
                     error_channel  => { 'type' => 'memory',
                                         'capacity' => '1000'
                                       }
                  },
                     # NetCat TCP source
      sources  => {  access_source  => { 'type' => 'netcat',
                                         'bind' => $flume_agent_node,
                                         'port' => '5001',
                                         'channels' => 'access_channel'
                                       },
                     # Describe/configure Apache error log source
                     # NetCat TCP source
                     error_source   => { 'type' => 'netcat',
                                         'bind' => $flume_agent_node,
                                         'port' => '5002',
                                         'channels' => 'error_channel'
                                       }
                  },
                     # Avro sink for Apache access log
      sinks    => {  access_avro_sink => { 'type' => 'avro',
                                           'hostname' => $flume_collector_node,
                                           'port' => '4545',
                                           'connect-timeout' => '1000',
                                           'request-timeout' => '1000',
                                           'batch-size' => '25',
                                           'channel' => 'access_channel',
                                         },
                     # Avro sink for Apache error log
                     error_avro_sink  => { 'type' => 'avro',
                                           'hostname' => $flume_collector_node,
                                           'port' => '4546',
                                           'connect-timeout' => '1000',
                                           'request-timeout' => '1000',
                                           'batch-size' => '25',
                                           'channel' => 'error_channel',
                                         }
                  }
    }
}

