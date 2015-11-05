#
# Configures elasticsearch as a standalone or cluster node
#

# aws_* parameters are optional and needed only for AWS deployment
# force_aws_plugin(true) will install AWS plugin even if deployment target is
#   not AWS. Possible usage scenario - S3 snapshot functionality
class profiles::elasticsearch (
  $aws_access_key         = undef,
  $aws_secret_key         = undef,
  $aws_region             = undef,
  $aws_groups             = undef,
  $aws_availability_zones = undef,
  $aws_host_type          = 'private_ip',
  $aws_ping_timeout_sec   = 30,
  $force_aws_plugin       = false,
  $num_nodes              = 1,
  $cluster_name
) {
  include profiles::linux
  
  $is_aws = ($::ec2_metadata != undef)
  $heap_size = ($::memorysize_mb/2).floor
  $instance_name = 'es-01'

  validate_string($cluster_name)
  validate_integer($num_nodes, undef , 1)
  
  $min_master_nodes = ($num_nodes/2).floor + 1
  
  $config_common = {
    'cluster.name'                        => $cluster_name,
    'index.number_of_replicas'            => 1,
    'index.number_of_shards'              => 1,
    'bootstrap.mlockall'                  => true,
    'discovery.zen.minimum_master_nodes'  => $min_master_nodes,
    'gateway.recover_after_time'          => '5m',
    'gateway.expected_nodes'              => $num_nodes,
    'gateway.type'                        => 'local',
    'indices.fielddata.cache.size'        => '50%',
    'indices.cache.filter.size'           => '10%',
    'indices.recovery.concurrent_streams' => 3,
    'indices.recovery.max_bytes_per_sec'  => '40mb',
    'action.destructive_requires_name'    => false,
    'threadpool.search.queue_size'        => 3000,
  }
  
  $cluster_routing = {
    'cluster.routing.allocation.cluster_concurrent_rebalance'      => 2,
    'cluster.routing.allocation.node_concurrent_recoveries'        => 2,
    'cluster.routing.allocation.node_initial_primaries_recoveries' => 4,
    'cluster.routing.allocation.disk.threshold_enabled'            => true,
    'cluster.routing.allocation.disk.watermark.low'                => 0.85,
    'cluster.routing.allocation.disk.watermark.high'               => 0.9,
  }
  
  if($is_aws) {
    validate_string($aws_access_key)
    validate_string($aws_secret_key)
    validate_string($aws_region)
    validate_string($aws_groups)
    validate_string($aws_availability_zones)
    validate_string($aws_host_type)
    validate_integer($aws_ping_timeout_sec, undef, 1)
    $config_cloud_initial = {
      'cloud.aws.access_key'                 => $aws_access_key,
      'cloud.aws.secret_key'                 => $aws_secret_key ,
      'cloud.aws.region'                     => $aws_region,
      'discovery.type'                       => 'ec2',
      'discovery.ec2.host_type'              => $aws_host_type,
      'discovery.ec2.ping_timeout'           => "${aws_ping_timeout_sec}s",
      'discovery.zen.ping.multicast.enabled' => false,
    }

    if($aws_groups) {
      $config_aws_groups = { 'discovery.ec2.groups' => $aws_groups }
    } else {
      $config_aws_groups = {}
    }

    if($aws_availability_zones) {
      $config_aws_availability_zones = { 'discovery.ec2.availability_zones' => $aws_availability_zones }
    } else {
      $config_aws_availability_zones = {}
    }

    $config_cloud = $config_cloud_initial + $config_aws_groups + $config_aws_availability_zones
  } else {
    $config_cloud = {
      'discovery.zen.ping.multicast.enabled' => true,
    }
  }
  
  class { 'elasticsearch':
    package_url   => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.7.1.noarch.rpm',
    config        => $config_common + $cluster_routing + $config_cloud,
    datadir       => ['/var/lib/elasticsearch'],
    init_defaults => {
      'ES_HEAP_SIZE'      => "${heap_size}m",
      'MAX_OPEN_FILES'    => 65535,
      'MAX_LOCKED_MEMORY' => 'infinity',
      'JAVA_HOME'         => '/usr/java/default'
    }
  }
  
  elasticsearch::instance { $instance_name: }
  elasticsearch::plugin{'mobz/elasticsearch-head':
    module_dir => 'head',
    instances  => $instance_name
  }
  elasticsearch::plugin{'elasticsearch/marvel/latest':
    module_dir => 'marvel',
    instances  => $instance_name
  }
  
#  elasticsearch::template { 'apache-logs':
#      file => 'puppet:///modules/profiles/elasticsearch-template.json'
#  }

  if($is_aws or $force_aws_plugin) {
    elasticsearch::plugin { 'elasticsearch/elasticsearch-cloud-aws/2.5.1':
      instances => $instance_name}
  }
  
}
