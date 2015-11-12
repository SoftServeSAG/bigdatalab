#
# Cloudera Director cluster deployment definition
#
define cloudera_director_client::deployment (
  $deploy_cluster = false,         # [true | false] If false, cluster won't be deployed to AWS. Otherwise it will. Set to false by default
  $cd_version =  '1.5.1',          # Cloudera Director (CD) version
  $redhat_version = '6',           # CD supported RedHat or CentOS version
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
  $data_node_quantity,             # Number of data nodes that will be deployed by cloudera director
  $data_node_quantity_min_allowed, # Minimum number of instances required to set up the cluster.
  $user_home_path,                 # Home path on machine where cloudera director client deployed
  $cluster_deployment_timeout_sec  # Cluster deployment timeout. It has to be changed depends on cluster size.
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

  # Java has to be installed from cloudera repositories. (Based on Cloudera reccomendtions)
  package { "oracle-j2sdk1.7":
    ensure  => installed,
    require => Yumrepo["cloudera-director"]
  }

  file { $cloudera_director_configs_path:
    require => Package['cloudera-director-client'],
    content => template('cloudera_director_client/cloudera-director.conf.erb'),
  }

  if $deploy_cluster {
    exec { 'start-cluster-deployment':
      command   => "cloudera-director bootstrap $cloudera_director_configs_path",
      timeout   => $cluster_deployment_timeout_sec,
      logoutput => true
    }
  } else {
    warning('Cluster deployment is turned off by default. To deploy cluster to AWS with Cloudera Director Client set deploy_cluster parameter to true')
  }
}