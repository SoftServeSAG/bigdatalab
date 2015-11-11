# cloudera_director_client::deployment

#### Table of Contents
1. [Module Description](#module-description)
2. [Setup](#setup)   
3. [Usage](#usage)
4. [Reference](#reference)

## Module Description
Puppet module for cluster deployment by Cloudera Director Client. 
Main goal of the module is to install *cloudera-director-client* and deploy cluster on AWS EC2 instances.

##Setup
1. General cluster configuration is stored in *'templates/cloudera-director.conf.erb'* It contains AWS environmental properties which is core for any cluster structure
2. More specific cluster configuration (like cluster infrastructure) placed in *'templates/cluster-specific.conf.erb'*

##Usage

```
  cloudera_director_client::deployment { 'Test-Cluster' :
    cd_version                     =>  '1.5.1',
    redhat_version                 => '6',
    instance_name_prefix           => $instance_name_prefix,
    data_node_quantity             => $data_node_quantity,
    data_node_quantity_min_allowed => $data_node_quantity_min_allowed, 
    aws_access_key_id              => $aws_access_key,
    aws_secret_access_key          => $aws_secret_key,
    aws_region                     => $aws_region,
    aws_security_group_ids         => $aws_security_group_id,
    aws_ssh_username               => $aws_ssh_username,
    aws_ami                        => $aws_ami,
    aws_ssh_private_key            => $private_key_path,
    aws_tag_env                    => $profiles::common::aws_tag_env,
    aws_tag_owner                  => $profiles::common::aws_tag_owner,
    user_home_path                 => $instance_home_path,
    cluster_deployment_timeout_sec => $cluster_deployment_timeout_sec
  }
```

##Reference

1. Parameters:
- cd_version                      Cloudera Director (CD) version. (Default: 1.5.1)
- redhat_version                  CD supported RedHat or CentOS version (Default: 6)
- instance_name_prefix            Prefix that will be added to all instances names, deployed by cloudera director
- data_node_quantity              Number of cluster data nodes deployed on AWS
- data_node_quantity_min_allowed  Min number of cluster data nodes allowed to be deployed to aws. Otherwice process will fail
- aws_access_key_id               AWS access key id
- aws_secret_access_key           AWS secret access key
- aws_region                      AWS region
- aws_security_group_ids          AWS secutiry group
- aws_ssh_username                AWS EC2 username
- aws_ami                         AWS AMI
- aws_ssh_private_key             Direct path to private key on the cloudera director instance machine. 
- aws_tag_env                     AWS instance tag
- aws_tag_owner                   AWS instance tag
- user_home_path                  Home path on machine where cloudera director client deployed
- cluster_deployment_timeout_sec  Cluster deployment timeout in seconds. It has to be changed depends on cluster size.