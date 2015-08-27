#
# Configures elasticsearch as a standalone or cluster node
#

class profiles::elasticsearch (
  $num_nodes    = 1,
  $cluster_name = 'bdl-cluster',
  $data_dir     = undef,
  $aws_params   = undef
) {
  require profiles::linux
  
  $is_aws = ($::ec2_instance_id != undef)
  
  #Validation
  validate_bool($is_aws)
  validate_integer($num_nodes)
  validate_string($cluster_name)
  validate_string($data_dir)
  if( $is_aws==true ){
    validate_hash($aws_params)
    validate_string($aws_params[access_key])
    validate_string($aws_params[secret_key])
    validate_string($aws_params[region])
    validate_string($aws_params[host_type])
    validate_integer($aws_params[ping_timeout_sec])
  }
  
  $zen = {
    'ping.multicast.enabled' => ( !$is_aws ),
    'minimum_master_nodes'   => ( $num_nodes/2 + 1 )
  }
  
  $cloud = undef
  if( $is_aws ) {
    $cloud = {
      'aws' => {
        'access_key' => $aws_params[access_key],
        'secret_key' => $aws_params[secret_key],
        'region'     => $aws_params[region]
      }
    }
    $discovery = {
      'type' => 'ec2',
      'ec2'  => {
        'groups'             => $::ec2_security_groups,
        'host_type'          => $aws_params[host_type],
        'ping_timeout'       => ($aws_params[ping_timeout_sec]+'s'),
        'availability_zones' => $::ec2_placement_availability_zone
      },
      'zen'  => $zen
    }
  } else {
    $discovery = {
      'zen' => $zen
    }
  }
  
  $config = {
    'cluster.name'           => $cluster_name,
    'gateway.expected_nodes' => $num_nodes,
    'cloud'                  => $cloud,
    'discovery'              => $discovery
  }
  
  $heap_size = $::memorysize_mb/2
  
  class { 'elasticsearch':
    config        => $config,
    init_defaults => {
      'ES_HEAP_SIZE' => "#{heap_size}m",
      'JAVA_HOME'    => $jdk_oracle::java_home
    }
  }
}
