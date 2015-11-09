# cloudera_director::deployment

#### Table of Contents
1. [Module Description](#module-description)
2. [Setup](#setup)   
3. [Usage](#usage)
4. [Reference](#reference)

## Module Description
Puppet module for cluster deployment by Cloudera Director. 
Main goal of the module is to install *cloudera-director-client* and deploy cluster on AWS EC2 instances.

##Setup
1. General cluster configuration is stored in *'templates/cloudera-director.conf.erb'* It contains AWS environmental properties which is core for any cluster structure
2. More specific cluster configuration (like cluster infrastructure) placed in *'templates/cluster-specific.conf.erb'*

##Usage

```
  cloudera_director::deployment { 'Test-Cluster' :
    cd_version =>  '1.5.1',  # (Default) Cloudera Director (CD) version
    redhat_version => '6',   # (Default) CD supported RedHat or CentOS version
    instance_name_prefix   => $instance_name_prefix,
    aws_access_key_id      => $aws_access_key,
    aws_secret_access_key  => $aws_secret_key,
    aws_region             => $aws_region,
    aws_security_group_ids => $aws_security_group_id,
    aws_ssh_username       => $aws_ssh_username,
    aws_ami                => $aws_ami,
    aws_ssh_private_key    => $private_key_path
  }
```

##Reference

1. Parameters:
- cd_version             Cloudera Director (CD) version. (Default: 1.5.1)
- redhat_version         CD supported RedHat or CentOS version (Default: 6)
- instance_name_prefix   Prefix that will be added to all instances names, deployed by cloudera director
- aws_access_key_id      AWS access key id
- aws_secret_access_key  AWS secret access key
- aws_region             AWS region
- aws_security_group_ids AWS secutiry group
- aws_ssh_username       AWS EC2 username
- aws_ami                AWS AMI
- aws_ssh_private_key    Direct path to private key
