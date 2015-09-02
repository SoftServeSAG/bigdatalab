#
# Configures elasticsearch as a standalone or cluster node
#

class profiles::elasticsearch (
  $num_nodes              = 1,
  $cluster_name           = undef,
  $data_dir               = '/var/lib/elasticsearch',
  $aws_access_key         = undef,
  $aws_secret_key         = undef,
  $aws_region             = undef,
  $aws_groups             = undef,
  $aws_host_type          = undef,
  $aws_ping_timeout       = undef,
  $aws_availability_zones = undef
) {
  include profiles::linux
  
  #TODO use facter to detect AWS
  $is_aws = true
  #TODO use facter to detect RAM amount
  $ram_amount_gb = 2
  
  class {'wget':}
  class {'jdk_oracle': } ->
  class { 'elasticsearch':
    package_url   => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.7.1.noarch.rpm',
    config        => {
      'cluster'    => {
        'name'    => $cluster_name
        'routing' => {
          'allocation' => {
            'cluster_concurrent_rebalance'      => 2,
            'node_concurrent_recoveries'        => 2,
            'node_initial_primaries_recoveries' => 4
            'disk'                              => {
              'threshold_enabled' => true
              'watermark'         => {
                'low'  => 0.85,
                'high' => 0.9
              }
            }
          }
        }
      },
      'index'      => {
        'number_of_replicas' => 1,
        'number_of_shards'   => 1
      },
      'bootstrap'  => {
        'mlockall' => true
      },
      'cloud'      => {
        'aws' => {
          'access_key' => $aws_access_key,
          'secret_key' => $aws_secret_key ,
          'region'     => $aws_region
        }
      },
      'discovery'  => {
        'type' => 'ec2', #aws only
        'ec2'  => { #aws only
          'groups'             => $aws_groups,
          'host_type'          => $aws_host_type,
          'ping_timeout'       => $aws_ping_timeout,
          'availability_zones' => $aws_availability_zones
        },
        'zen'  => {
          'ping'                 => {
            'multicast' => {
              'enabled' => ( !$is_aws )
            }
          },
          #single-node cluster will not work if minimum_master_nodes > 1
          'minimum_master_nodes' => ( $num_nodes/2 + 1 )
        }
      },
      'gateway'    => {
        'recover_after_time' => '5m',
        'expected_nodes'     => $num_nodes,
        'type'               => 'local' #TODO check if ok
      },
      'indices'    => {
        'fielddata' => {
          'cache' => {
            'size' => '50%'
          }
        },
        'cache'     => {
          'filter' => {
            'size' => '10%'
          }
        },
        'recovery'  => {
          'concurrent_streams' => 3,
          'max_bytes_per_sec'  => '40mb'
        }
      },
      'action'     => {
        'destructive_requires_name' => false
      },
      'threadpool' => {
        'search' => {
          'queue_size' => 3000
        }
      }
    },
    datadir       => $data_dir
    init_defaults => {
      'ES_HEAP_SIZE'      => ( ($ram_amount_gb/2)+'g' ),
      'MAX_OPEN_FILES'    => 65535,
      'MAX_LOCKED_MEMORY' => 'infinity'
      'JAVA_HOME'         => $jdk_oracle::java_home
    }
  }
  
}
