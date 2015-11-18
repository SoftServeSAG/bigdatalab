#!/bin/bash

# Does preparation of an environment which is common for each puppet role
prepareCommonEnv() {
    sudo yum -y install yum-plugin-fastestmirror
    sudo yum -y update
    sudo yum -y remove java-*-openjdk
    sudo rpm -U https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm
    sudo yum -y install puppet-agent
    sudo ln -sf /opt/puppetlabs/puppet/bin/puppet /usr/bin/puppet
}

prepareCommonEnv

scriptPath=$(readlink -f "$0")
scriptDir=$(dirname "$scriptPath")
cd $scriptDir

if [ -n "$PUPPET_ROLE" ]; then
   sudo puppet apply --modulepath modules --hiera_config=hiera/hiera.yaml --yamldir hiera manifests/$PUPPET_ROLE.pp
fi
