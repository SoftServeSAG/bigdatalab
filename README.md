#### Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Roadmap](#roadmap)
4. [Tested OS](#tested-os)
5. [Deployment guide](#deployment-guide)   
6. [Cloudera cluster management](#cloudera-cluster-management)

##Overview
###Marketecture

##Architecture
###Architecture Drivers

###Test

##Roadmap

##Tested OS
Below is a list of client OS which can be used to deploy solution from:
- CentOS 6/7 (64 bit)
- Ubuntu 14 (64 bit)
- OSX

##Deployment guide
1. Run:

   ```
   sudo ./core-install.sh
   ./ruby-install.sh
   ./terraform-install.sh
   source $HOME/.bashrc
   ```

2. Copy puppet/hiera/hieradata/common.yaml-[small|medium|large] to common.yaml.
   Update it, if needed.
   
3. To turn on cluster deployment, change *'profiles::cloudera_director_client::deploy_cluster'* property in common.yaml to *true*
   To get additional information about cluster configuration see ['cluster management'](#cloudera-cluster-management) section.

4. Copy main.tf-[small|medium|large] to main.tf.

5. Prepare .pem file to be used for SSH connections.

6. Copy terraform.tfvars.stub to terraform.tfvars.  Update it with actual values.  You may also override other values from variables.tf.

7. To run unit tests, go to puppet folder and run:

   ```
   bundle exec rake prep
   bundle exec rake rspec:classes
   bundle exec rake clean
   ```

   Unit tests are being run during each terraform apply too.

8. To run acceptance tests, go to puppet folder and run:

   ```
   bundle exec rake prep
   bundle exec rake rspec:acceptance
   bundle exec rake clean
   ```

   Please note, that you need a physical machine to be able to run acceptance
   tests.

9. To create instances, run:

   ```
   terraform apply
   ```

   If "Error launching source instance: InvalidParameterValue: Value () for
   parameter groupId is invalid. The value cannot be empty" error appears,
   just restart the command.

10. To connect to any instance:

   ```
   ssh -i <your .pem file> <SSH user>@<IP address>
   ```

   You can find SSH users for all AMIs in variables.tf.

11. ***Warning:*** If your turned on a cluster deployment (step #3), log to the machine where Cloudera Director Client is running and terminate the cluster with the console command:

   ```
   cloudera-director terminate {path to cluster configuration file}
   ```

12. To destroy instances, run:
     
   ```
   terraform destroy
   ```

##Cloudera cluster management

Cluster is deployed to AWS by Cloudera director client tool. It is installed to AWS instance as a 'cloudera_director_client' terraform resource.

Before starting a deployment, cluster can be customized depending on specific needs.
A default cluster presets were extracted to 'hiera/hieradata/common.yaml-[small|medium|large]' configuration files.

Mentioned properties described in the table below. 

Property | Description | Small | Medium | Large
---|---|---|---|---
*profiles::cloudera_director_client ::deploy_cluster* | When false, cluster won't be deployed to AWS. Otherwise it will. Set to false if you don't want to deploy cluster and to manage it outside the project | false | false | false 
*profiles::cloudera_director_client ::root_volume_size_GB* | Size in GB that can be allocated for each instance in the cluster | 50 | 100 | 300
*profiles::cloudera_director_client ::data_node_quantity* | Number of instances deployed on AWS and used in data nodes roles. Minimum recommended 3 | 1 | 3 | 10  
*profiles::cloudera_director_client ::data_node_quantity_min_allowed* | Minimal number of cluster data nodes allowed to be deployed to AWS. In case the number of instances can not be reached, cluster deployment will fail | 1 | 3 | 10
*profiles::cloudera_director_client ::data_node_instance_type* | AWS instance type for data nodes to be deployed  | t2.medium | t2.medium | m4.xlarge
*profiles::cloudera_director_client ::cloudera_manager_instance_type* | AWS instance type for Cloudera Manager to be deployed | t2.large | t2.large | m4.large
*profiles::cloudera_director_client ::master_node_instance_type* | AWS instance type for master cluster services to be run on | t2.large | m4.2xlarge | m4.4xlarge 
*profiles::cloudera_director_client ::aws_ami* | AWS image to be used for each cluster instance | ami-3218595b | ami-3218595b | ami-3218595b
*profiles::cloudera_director_client ::cluster_deployment_timeout_sec* | Cluster deployment timeout in seconds. In order of increasing number of nodes, timeout has to be also increased | 7200 | 7200 | 7200

#####How to use a Cloudera Manager UI

After completion a Terraform environment applying stage, cluster can be accessed with Cloudera Manager (CM) UI.
To open CM UI locate CM IP address in Terraform output and open the following URL in a browser:

http://ClouderaManagerIP:7180

To login into CM UI use: 
- username: 'admin' 
- password: 'admin'

#####Managing The Cluster outside of the puppet based project.

Before project deployment set *profiles::cloudera_director_client::deploy_cluster* property to *false*  (false by default)

######To manage cluster:
1. Connect by ssh to the resource 'cloudera_director_client' created by terraform. 
2. Locate 'cloudera-director-cluster.conf' configuration file. (Default path is '/home/ec2-user')
3. Go to the configuration file's directory and modify the configuration.

- To validate cluster configuration run:
 ```
  cloudera-director validate cloudera-director-cluster.conf
 ```

- To create cluster run:
 ```
 cloudera-director bootstrap cloudera-director-cluster.conf
 ```

- To modify cluster edit the configuration file and run:
 ```
 cloudera-director update cloudera-director-cluster.conf
 ```

- To check cluster status run:
 ```
 cloudera-director status cloudera-director-cluster.conf
 ```

#####Services that are running on cluster instances.

1. Cloudera Manager services on separate instance.
2. On master nodes:
 - HDFS 
 - YARN
 - ZOOKEEPER
 - HIVE
 - HUE
 - OOZIE
 - IMPALA
3. On slave nodes:
 - HDFS 
 - YARN
 - IMPALA
