variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-1"
}
variable "amis" {
  default = {
    centos-6.5 = "ami-8c1224e4"
#    centos-6.5 = "ami-9ade2af2"
    centos-7.0 = "ami-b2c505da"
  }
}
variable "os_version" {
  default = "centos-6.5"
}
variable "instance_type" {
  default = "t1.micro"
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
variable "key_file" {}
variable "public_key" {}
