variable "access_key" {}
variable "secret_key" {}
variable "key_file" {}
variable "public_key" {}
variable "vpc_subnet_id" {}
variable "tag_owner" {}

variable "tag_app" {
  default = "bigdatalab"
}
variable "tag_env" {
  default = "development"
}
variable "region" {
  default = "us-east-1"
}
variable "instance_types" {
  default = {
    log_generator = "t1.micro"
    flume = "t1.micro"
    kibana = "t1.micro"
    elasticsearch = "t1.micro"
    cloudera_director_client = "t1.micro"
    elasticsearch_kibana = "t1.micro"
    log_generator_flume = "t1.micro"
  }
}
variable "os_versions" {
  default = {
    default = "centos-6.5"
    log_generator = "centos-7.0"
  }
}
variable "security_group" {
  default = "bigdatalab-group"
}
variable "key_name" {
  default = "bigdatalab-key"
}
variable "puppet_path" {
  default = "/tmp"
}

variable "amis" { # for us-east-1 region
  default = {
    centos-6.5 = "ami-9ade2af2" # CentOS-6.5-x86_64-PV-cloudinit
    centos-7.0 = "ami-b2c505da" # CentOS 7.0 x86_64 with cloud-init (PV)
  }
}
variable "users" {
  default = {
    ami-9ade2af2 = "ec2-user"
    ami-b2c505da = "ec2-user"
  }
}
