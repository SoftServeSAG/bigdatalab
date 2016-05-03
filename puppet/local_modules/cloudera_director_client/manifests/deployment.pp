#
# Cloudera Director cluster deployment definition
#
define cloudera_director_client::deployment (
  $deploy_cluster = false,         # [true | false] If false, cluster won't be deployed to AWS. Otherwise it will. true by default
  $cd_version = '2.0.0',           # Cloudera Director (CD) version
  $redhat_version = '7',           # CD supported RedHat or CentOS version
  $instance_name_prefix,           # Prefix that will be added by CD during instance deployment
  $aws_access_key_id,
  $aws_secret_access_key,
  $aws_region,
  $aws_security_group_ids,
  $aws_subnetId,
  $aws_ssh_username,
  $aws_ssh_private_key,            # An absolute path to .pem file
  $aws_tag_env,                    # AWS instance tag to identify deployment environment
  $aws_tag_owner,                  # AWS instance tag to identify environment owner
  $root_volume_size_GB,            # AWS volume size has to be allocated for each cluster node. Root partition on each node will be resized accordingly
  $data_node_quantity,             # Number of data nodes that will be deployed by cloudera director
  $data_node_quantity_min_allowed, # Minimum number of instances required to set up the cluster.
  $data_node_instance_type,        # AWS instance type for data node
  $cloudera_manager_instance_type, # AWS instance type for Cloudera Manager
  $master_node_instance_type,      # AWS instance type for master node
  $aws_ami,                        # AWS AMI type for all cluster nodes
  $user_home_path,                 # Home path on machine where cloudera director client deployed
  $cluster_deployment_timeout_sec, # Cluster deployment timeout. It has to be changed depends on cluster size.
  $hdfs_replication_factor         # HDFS replication factor
) {

  include cloudera_director_client

  $cluster_name = $name
  $cluster_specific_config = template("cloudera_director_client/cluster-specific.conf.erb")
  $cloudera_director_configs_path = "$user_home_path/cloudera-director-cluster.conf"
  $exec_path = ['/bin', '/sbin', '/usr/bin', '/usr/sbin']

  Exec { path => $exec_path }

  yumrepo { "cloudera-director":
    baseurl  => "http://archive.cloudera.com/director/redhat/$redhat_version/x86_64/director/$cd_version/",
    descr    => "Packages for Cloudera Director, Version $cd_version, on RedHat or CentOS $redhat_version x86_64",
    gpgkey   => "http://archive.cloudera.com/director/redhat/$redhat_version/x86_64/director/RPM-GPG-KEY-cloudera",
    enabled  => 1,
    gpgcheck => 1,
  }

  package { "cloudera-director-client":
    ensure  => installed,
    require => Yumrepo["cloudera-director"]
  }

  package { "cloudera-director-server":
    ensure  => installed,
    require => Yumrepo["cloudera-director"]
  }

  service { "cloudera-director-server":
    ensure  => running,
    require => Package["cloudera-director-server"]
  }

  # Java has to be installed from cloudera repositories. (Based on Cloudera reccomendtions)
  package { "oracle-j2sdk1.7":
    ensure  => installed,
    require => Yumrepo["cloudera-director"]
  }

  file { $cloudera_director_configs_path:
    require => [ Package['cloudera-director-client'], Package["cloudera-director-server"] ],
    content => template('cloudera_director_client/cloudera-director.conf.erb')
  }

  if $deploy_cluster {
    exec { 'start-cluster-deployment':
      command   => "cloudera-director bootstrap-remote $cloudera_director_configs_path --lp.remote.username=admin --lp.remote.password=admin --lp.remote.hostAndPort=localhost:7189",
      timeout   => 0,
      try_sleep => 180,
      tries     => 3,
      logoutput => true,
      require   => File[$cloudera_director_configs_path]
    }
  } else {
    warning('Cluster deployment is turned off. To deploy cluster to AWS with Cloudera Director Client set deploy_cluster parameter to true')
  }
}
