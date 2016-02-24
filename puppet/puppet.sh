#!/bin/bash

release=$(rpm -q --queryformat '%{VERSION}' centos-release)

# Does preparation of an environment which is common for each puppet role
prepareCommonEnv() {
    sudo yum -y install yum-plugin-fastestmirror
    sudo yum -y update
    sudo yum -y install wget
    sudo yum -y remove java-*-openjdk
    sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-$release.noarch.rpm
    sudo yum -y install puppet
}

prepareCommonEnv

scriptPath=$(readlink -f "$0")
scriptDir=$(dirname "$scriptPath")
cd $scriptDir

if [ -n "$PUPPET_ROLE" ]; then
   sudo puppet apply --modulepath modules --hiera_config=hiera/hiera.yaml --yamldir hiera manifests/$PUPPET_ROLE.pp
fi
