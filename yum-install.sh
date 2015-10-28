#!/usr/bin/env bash
if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

yum -y install yum-plugin-fastestmirror
yum -y update
yum -y groupinstall "Development tools"
yum -y install openssl-devel readline-devel zlib-devel
yum -y install git unzip wget
yum -y install https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.rpm
if [[ $(cat /etc/redhat-release | grep ' 7') != '' ]]; then
  yum -y install http://download.virtualbox.org/virtualbox/5.0.8/VirtualBox-5.0-5.0.8_103449_el7-1.x86_64.rpm
else
  yum -y install http://download.virtualbox.org/virtualbox/5.0.8/VirtualBox-5.0-5.0.8_103449_el6-1.x86_64.rpm
fi
