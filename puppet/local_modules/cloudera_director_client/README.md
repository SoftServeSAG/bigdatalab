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
    deploy_cluster                 => true 
    cd_version                     => '2.0.0',
    redhat_version                 => '7',
    instance_name_prefix           => $instance_name_prefix,    
    aws_access_key_id              => $aws_access_key,
    aws_secret_access_key          => $aws_secret_key,
    aws_region                     => $aws_region,
    aws_security_group_ids         => $aws_security_group_id,
    aws_ssh_username               => $aws_ssh_username,
    aws_ssh_private_key            => $private_key_path,
    aws_tag_env                    => $profiles::common::aws_tag_env,
    aws_tag_owner                  => $profiles::common::aws_tag_owner,
    root_volume_size_GB            => $root_volume_size_GB,
    data_node_quantity             => $data_node_quantity,
    data_node_quantity_min_allowed => $data_node_quantity_min_allowed, 
    data_node_instance_type        => $data_node_instance_type,
    cloudera_manager_instance_type => $cloudera_manager_instance_type,
    master_node_instance_type      => $master_node_instance_type,
    aws_ami                        => $aws_ami,
    user_home_path                 => $instance_home_path,
    cluster_deployment_timeout_sec => $cluster_deployment_timeout_sec,
    hdfs_replication_factor        => $hdfs_replication_factor
  }
```

##Reference

1. ***Parameters***:
- **deploy_cluster**                 - [true | false] If false, cluster won't be deployed to AWS. Otherwise it will. **true** by default
- **cd_version**                     - Cloudera Director (CD) version.
- **redhat_version**                 - CD supported RedHat or CentOS version
- **instance_name_prefix**           - Prefix that will be added to all instances names, deployed by cloudera director
- **aws_access_key_id**              - AWS access key id
- **aws_secret_access_key**          - AWS secret access key
- **aws_region**                     - AWS region
- **aws_security_group_ids**         - AWS secutiry group
- **aws_ssh_username**               - AWS EC2 username
- **aws_ssh_private_key**            - Direct path to private key on the cloudera director instance machine. 
- **aws_tag_env**                    - AWS instance tag
- **aws_tag_owner**                  - AWS instance tag
- **root_volume_size_GB**            - AWS volume size to be allocated for each node. Root partition on each node will be resized accordingly.
- **data_node_quantity**             - Number of cluster data nodes to be deployed on AWS
- **data_node_quantity_min_allowed** - Min number of cluster data nodes successfully deployed to AWS, otherwise the process will fail
- **data_node_instance_type**        - AWS instance type for data node
- **cloudera_manager_instance_type** - AWS instance type for Cloudera Manager
- **master_node_instance_type**      - AWS instance type for master node
- **aws_ami**                        - AWS AMI type for all cluster nodes
- **user_home_path**                 - Home path on machine where cloudera director client deployed
- **cluster_deployment_timeout_sec** - Cluster deployment timeout in seconds. It should be changed depending on the cluster size.
- **hdfs_replication_factor**        - HDFS replication factor
