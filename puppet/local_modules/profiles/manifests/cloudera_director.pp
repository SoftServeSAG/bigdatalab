class profiles::cloudera_director (
    $instance_name_prefix,
    $private_key_path) {

  require profiles::common

  cloudera_director::deployment { 'Test-Cluster' :
    instance_name_prefix   => $instance_name_prefix,
    aws_access_key_id      => $profiles::common::aws_access_key,
    aws_secret_access_key  => $profiles::common::aws_secret_key,
    aws_region             => $profiles::common::aws_region,
    aws_security_group_ids => $profiles::common::aws_security_group_id,
    aws_ssh_username       => $profiles::common::aws_ssh_username,
    aws_ami                => $profiles::common::aws_ami,
    aws_ssh_private_key    => $private_key_path

  }
}