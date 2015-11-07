#
# Cloudera Director cluster deployment definition
#
define cloudera_director::deployment (
  $cd_version =  '1.5.1',  # Cloudera Director (CD) version
  $redhat_version = '6',   # CD supported RedHat or CentOS version
  $instance_name_prefix,   # Prefix that will be added by CD during instance deployment
  $aws_access_key_id,
  $aws_secret_access_key,
  $aws_region,
  $aws_security_group_ids,
  $aws_ssh_username,
  $aws_ssh_private_key,    # An absolute path to .pem file
  $aws_ami
) {

  include cloudera_director

  $cluster_name = $name
  $cluster_specific_config = template("cloudera_director/cluster-specific.conf.erb")


# Adding yum repo
  yumrepo { "cloudera-director":
    baseurl  => "http://archive.cloudera.com/director/redhat/$redhat_version/x86_64/director/$cd_version/",
    descr    => "Packages for Cloudera Director, Version $cd_version, on RedHat or CentOS $redhat_version x86_64",
    gpgkey   => "http://archive.cloudera.com/director/redhat/$redhat_version/x86_64/director/RPM-GPG-KEY-cloudera",
    enabled  => 1,
    gpgcheck => 1,
  }

# Installing Cloudera director client
  package { "cloudera-director-client":
    ensure  => installed,
    require => Yumrepo["cloudera-director"]
  }

  file { '/etc/cloudera-director-cluster.conf':
    require => Package['cloudera-director-client'],
    content => template('cloudera_director/cloudera-director.conf.erb'),
  }

  # TODO bk Execute cloudera director to deploy cluster
}