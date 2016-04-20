variable "access_key" {}
variable "secret_key" {}
variable "vpc_subnet_id" {}
variable "key_file" {}
variable "public_key" {}
variable "tag_owner" {}
variable "tag_app" {}
variable "tag_env" {}
variable "security_group" {}
variable "key_name" {}
variable "cluster_name" {}
variable "deploy_cloudera_cluster" {}

variable "puppet_path" {
  default = "/tmp"
}
variable "region" {
  default = "us-east-1"
}
variable "instance_types" {
  default = {
    log_generator = "t2.micro"
    flume = "t2.micro"
    kibana = "t2.micro"
    elasticsearch = "t2.small"
    cloudera_director_client = "t2.small"
    elasticsearch_kibana = "t2.small"
    log_generator_flume = "t2.small"
  }
}
variable "os_versions" {
  default = {
    default = "centos-7.1"
  }
}
variable "amis" { # for us-east-1 region
  default = {
    centos-7.1 = "ami-91e416fa" # CentOS 7.1 x86_64 with cloud-init (PV)
  }
}
variable "users" {
  default = {
    ami-91e416fa = "ec2-user"
  }
}
