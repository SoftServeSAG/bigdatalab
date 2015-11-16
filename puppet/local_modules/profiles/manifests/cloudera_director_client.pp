class profiles::cloudera_director_client (
    $deploy_cluster,
    $cluster_name,
    $instance_name_prefix,
    $private_key_path,
    $data_node_quantity,
    $data_node_quantity_min_allowed,
    $instance_home_path,
    $cluster_deployment_timeout_sec) {

  require profiles::common

  cloudera_director_client::deployment { $cluster_name :
    deploy_cluster                 => $deploy_cluster,
    instance_name_prefix           => $instance_name_prefix,
    data_node_quantity             => $data_node_quantity,
    data_node_quantity_min_allowed => $data_node_quantity_min_allowed,
    aws_access_key_id              => $profiles::common::aws_access_key,
    aws_secret_access_key          => $profiles::common::aws_secret_key,
    aws_region                     => $profiles::common::aws_region,
    aws_security_group_ids         => $profiles::common::aws_security_group_id,
    aws_subnetId                   => $profiles::common::aws_subnetId,
    aws_ssh_username               => $profiles::common::aws_ssh_username,
    aws_ssh_private_key            => $private_key_path,
    aws_tag_env                    => $profiles::common::aws_tag_env,
    aws_tag_owner                  => $profiles::common::aws_tag_owner,
    user_home_path                 => $instance_home_path,
    cluster_deployment_timeout_sec => $cluster_deployment_timeout_sec
  }
}