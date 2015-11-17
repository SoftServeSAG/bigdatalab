#!/bin/bash

# Does preparation of an environment which is common for each puppet role
prepareCommonEnv() {
    sudo yum -y install yum-plugin-fastestmirror
    #sudo yum -y update
    sudo yum -y remove java-*-openjdk
    sudo rpm -U https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm
    sudo yum -y install puppet-agent
    sudo ln -sf /opt/puppetlabs/puppet/bin/puppet /usr/bin/puppet
}

prepareCommonEnv

scriptPath=$(readlink -f "$0")
scriptDir=$(dirname "$scriptPath")
cd $scriptDir


case "$PUPPET_ROLE" in
"log_generator_flume")
    sudo puppet apply --modulepath modules --hiera_config=hiera/hiera.yaml --yamldir hiera manifests/log_generator_flume.pp
    ;;
"elasticsearch_kibana")
    sudo puppet apply --modulepath modules --hiera_config=hiera/hiera.yaml --yamldir hiera manifests/elasticsearch_kibana.pp
    ;;
"cloudera_director_client")
    sudo puppet apply --modulepath modules --hiera_config=hiera/hiera.yaml --yamldir hiera manifests/cloudera_director_client.pp
    ;;
"log_generator")
    sudo puppet apply --modulepath modules --hiera_config=hiera/hiera.yaml --yamldir hiera manifests/log_generator.pp
    ;;
"flume")
   sudo puppet apply --modulepath modules --hiera_config=hiera/hiera.yaml --yamldir hiera manifests/flume.pp
   ;;
"elasticsearch")
   sudo puppet apply --modulepath modules --hiera_config=hiera/hiera.yaml --yamldir hiera manifests/elasticsearch.pp
   ;;
"kibana")
   sudo puppet apply --modulepath modules --hiera_config=hiera/hiera.yaml --yamldir hiera manifests/kibana.pp
   ;;
*)
  ;;
esac
