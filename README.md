#### Table of Contents
- [Overview](#overview)
   - [Marketecture](#marketecture)
- [Architecture](#architecture)
   - [Architecture Drivers](#architecture-drivers)
   - [Lambda Architecture](#lambda-architecture)
- [Data Flow](#data-flow)
- [Roadmap](#roadmap)
   - [Components](#components)
   - [Client OS Support](#client-os-support)
   - [Guest OS Support](#guest-os-support)
   - [Platform Support](#platform-support)
   - [Configuration Size](#configuration-size)
   - [Data Sources](#data-sources)
   - [Service Discovering](#service-discovering)
- [Tested OS](#tested-os)
- [Deployment guide](#deployment-guide) 
   - [Deploying Cluster](#deploying-cluster)
   - [Destroying Cluster](#destroying-cluster)
   - [Cloudera Cluster Deployment](#cloudera-cluster-deployment)
      - [Automatic Deployment](#automatic-deployment)
      - [Manual Deployment and Configuration](#manual-deployment-and-configuration)
      - [Cloudera Cluster Services](#cloudera-cluster-services)
      - [Cloudera Manager UI](#cloudera-manager-ui)



##Overview
Big Data Lab is an open-source project created originally in SoftServe Inc. to serve as an accelerator for big data projects and to be an easy to deploy and use environment for education, prototyping, PoC, performance testing and other purposes. The main idea which lies in the root of Big Data Lab is a Log and Metrics processing system which allows certain set of users to use both raw and aggregated log and performance metrics data in their daily tasks.

###Marketecture
Diagram below shows main sources of data (log and performance metrics data being collected from web servers), as well as 3 types of analytics produced based on this data and 3 types of users using this data.
![Image](../develop/misc/img/Marketecture.png?raw=true)


##Architecture
###Architecture Drivers
Below is a set of main architecture drivers which influences architecture and implementation of the project. We've used Carnegie Mellon Software Engineering Insitute's ADD (Attribute Driven Design) methodology in building solution architecture.
![Image](../develop/misc/img/ArchitectureDrivers.png?raw=true)

### Lambda Architecture

**Overview**

As part of the design process, one of the first tasks is to create an overall logical structure for the system. To achieve this, it is generally not necessary to re-invent the wheel, but rather to use one particular type of design concept: a reference architecture. A reference architecture is a blueprint for structuring an application. For Big Data Analytics systems we distinguish five reference architectures:

*   Traditional Relational
*   Extended Relational
*   Non-Relational
*   Lambda Architecture (Hybrid)
*   Data Refinery (Hybrid)

**Design Rational**

From the provided reference architectures [Lambda Architecture](http://lambda-architecture.net/) promises the largest number of benefits, such as access to real-time and historical data at the same time. The parallel layers provide “complexity isolation”, meaning that design decisions and development of each layer can be done independently – which corresponds to “swim lanes” principle that increase fault-tolerance and scalability (which is true for a system and for parallelizing development tasks).

The below diagram represents proposed logical structure of the target system based on Lambda Architecture:

![Image](../develop/misc/img/LambdaArchitecture.png?raw=true)

### Data Flow
![Image](../develop/misc/img/DataFlow.png?raw=true)

##Roadmap
###Components:
- [x] LogGenerator
- [x] Flume
- [x] ElasticSearch 1.7
- [ ] Elastic Search Automatic Schema Creation
- [x] Cloudera Director (Hadoop Cluster Deployment)
- [ ] Impala Schema Creation
- [x] Kibana
- [ ] Kibana: Automatic Pre-defined Dashboards Import
 
###Client OS Support:
- [x] Linux
- [x] MacOS

###Guest OS Support:
- [x] CentOS
- [ ] RedHat

###Platform Support:
- [x] Amazon Web Services
- [ ] VMWare vShpere / ESX
- [ ] OpenStack

###Configuration Size:
- [x] Small
- [x] Medium
- [x] Large

###Data Sources:
- [x] Log Files (HTTP, Error)
- [ ] Performance metrics
- [ ] IoT

###Service Discovering:
- [x] Built-in DNS with hostname self-registering
- [ ] Consul

##Tested OS
Below is a list of client OS which can be used to deploy solution from:
- CentOS 6/7 (64 bit)
- Ubuntu 14 (64 bit)
- OSX

##Product Versions
- Vagrant 1.8.1
- Virtualbox 5.0.8
- Terraform 0.6.14
- Ruby 2.2.4 (Bundler 1.10.5)
- Puppet 4.2.1
- Flume ???
- ElasticSearch 1.7.1 (Lucene Core 4.10.4)
- Kibana T.B.D.
- Cloudera Director 1.5.1

##Deployment Guide

Use the steps below in order to create Big Data Lab cluster:

1. Run:

   ```
   sudo ./core-install.sh
   ./puppet-install.sh
   ./terraform-install.sh
   source $HOME/.bashrc
   ```

2. Choose a profile that you want to use as a template (small, medium or large).

   Small:

   ```
   1 Log Generator + Flume Agent + Flume Collector
   1 ElasticSearch + Kibana
   1 Cloudera Director

   Cloudera CDH Cluster:
   1 Cloudera Manager
   1 Name Node
   1+ Data Node(s)
   ```

   Medium:

   ```
   1+ Log Generator + Flume Agent
   1 Flume Collector
   1 ElasticSearch + Kibana
   1 Cloudera Director

   Cloudera CDH Cluster:
   1 Cloudera Manager
   1 Name Node
   3+ Data Nodes
   ```

   Large:

   ```
   2+ Log Generator + Flume Agent
   1 Flume Collector
   2+ ElasticSearch
   1 Kibana
   1 Cloudera Director

   Cloudera CDH Cluster:
   1 Cloudera Manager
   1 Name Node
   5+ Data Nodes
   ```

3. According to the chosen profile, copy *puppet/hiera/hieradata/common.yaml-[small|medium|large]*
   to *puppet/hiera/hieradata/common.yaml*.  Review and update its content, if needed.

   Values, which may be changed:

   ```
   profiles::cloudera_director_client::root_volume_size_GB: AWS volume size to be allocated for each node. Root partition on each node will be resized accordingly.
   profiles::cloudera_director_client::data_node_quantity: Number of cluster data nodes to be deployed on AWS
   profiles::cloudera_director_client::data_node_quantity_min_allowed: Min number of cluster data nodes successfully deployed to AWS, otherwise the process will fail
   profiles::cloudera_director_client::data_node_instance_type: AWS instance type for data node
   profiles::cloudera_director_client::cloudera_manager_instance_type:  AWS instance type for Cloudera Manager
   profiles::cloudera_director_client::master_node_instance_type: AWS instance type for master node
   profiles::cloudera_director_client::cluster_deployment_timeout_sec: Cluster deployment timeout in seconds. It should be changed depending on the cluster size.
   profiles::cloudera_director_client::hdfs_replication_factor: HDFS replication factor
   ```

4. According to the chosen profile, copy *main.tf-[small|medium|large]* to *main.tf*.
   In medium and large profiles you may change the number of "node_log_generator" nodes.
   In large profile you may also change the number of "node_elasticsearch" nodes:

   ```
   count = 1
   ```

5. Prepare .pem file to be used for SSH connections.

6. Copy *terraform.tfvars.stub* to *terraform.tfvars*.  Update its content with actual values.
   You may also override other values from *variables.tf*, if needed.

   ```
   access_key: AWS Access Key Id
   secret_key: AWS Secret Access Key
   vpc_subnet_id: Existing AWS Subnet Id to be used
   key_file: Path to your .pem file
   public_key: Content of the public key for your .pem file
   tag_owner: "Owner" tag for instances (your name)
   tag_app: "App" tag for instances ("bigdatalab" by default)
   tag_env: "Env" tag for instances ("development" by default)
   security_group: Name for a new AWS Security Group ("bigdatalab-group" by default)
   key_name: Name for a new AWS Key Pair ("bigdatalab-key" by default)
   cluster_name: Name for the Cloudera cluster ("bigdatalab-cluster" by default)
   deploy_cloudera_cluster: Whether to deploy Cloudera cluster or not ("true" by default)
   ```

   Make sure that *security_group* and *key_name* with the specified names don't exist yet.

7. To run unit tests, go to *puppet* folder and run:

   ```
   bundle exec rake prep
   bundle exec rake rspec:classes
   bundle exec rake clean
   ```

   Please note that unit tests are automatically run during each terraform apply.

8. To run acceptance tests, go to *puppet* folder and run:

   ```
   bundle exec rake prep
   bundle exec rake rspec:acceptance
   bundle exec rake clean
   ```

   Please note that you need a physical machine to be able to run acceptance
   tests.

9. To create the infrastructure, run:

   ```
   terraform apply
   ```

10. To connect to any instance:

   ```
   ssh -i <your .pem file> <SSH user>@<IP address>
   ```

   You can find SSH users for all AMIs in *variables.tf*.

11. To destroy the infrastructure, you need to perform two steps:

   First, connect to the Cloudera Director Client instance and run:

   ```
   cloudera-director terminate-remote /home/ec2-user/cloudera-director-cluster.conf \
     --lp.remote.hostAndPort=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`:7189 \
     --lp.remote.username=<Cloudera Director username, "admin" by default> \
     --lp.remote.password=<Cloudera Director password, "admin" by default> \
     --lp.remote.terminate.assumeYes=true
   ```

   When done, run locally:

   ```
   terraform destroy
   ```

12. For a quick test you may do the following:

   Open ElasticSearch in a browser:

   ```
   http://<public_ip_node_elasticsearch>:9200/_count?pretty
   ```

   Make sure that *count* value is greater than 0 and increases after each refresh.

   Open Cloudera Director in a browser:

   ```
   http://<public_ip_node_cloudera_director>:7189
   ```

   Check "Yes, I accept the End User License Terms and Conditions" and click "Continue".
   Enter Username ("admin" by default) and Password ("admin" by default)

   Make sure that all services are "green".

   Click "bigdatalab-cluster Deployment" link in the table.  On the next screen click
   "View Properties" and copy *Public IP* value.

   Open Cloudera Manager in a browser:

   ```
   http://<Public IP from the last step>:7180
   ```

   Please note that Cloudera Manager UI may render incorrectly in FireFox.  If there is
   no data on some screen, just refresh that page.

   Make sure that everything is green.

   Click "HDFS-1" in the table.  On the next screen click "NameNode Web UI".
   On the next screen click Utilities -> Browse the file system.

   Navigate to */flume/logs* and make sure that there is some data.

### Cloudera CDH Cluster Installed Services

1. Cloudera Manager

2. Name Node:

 - HDFS 
 - YARN
 - Zookeeper
 - Hive
 - Hue
 - Oozie
 - Impala

3. Data Node(s):

 - HDFS 
 - YARN
 - Impala

