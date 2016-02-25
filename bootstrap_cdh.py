#! /usr/bin/env python
# Dependency modules pywebhdfs, cloudera-director-python-client

import sys
import ConfigParser
import argparse
import uuid
import time

from os.path import isfile
from urllib2 import HTTPError

from pywebhdfs.webhdfs import PyWebHdfsClient

from cloudera.director.latest.models import (Login, SshCredentials,
        InstanceProviderConfig, Environment, InstanceTemplate,
        VirtualInstance, DeploymentTemplate, ClusterTemplate,
        VirtualInstanceGroup)

from cloudera.director.common.client import ApiClient
from cloudera.director.latest import (AuthenticationApi, EnvironmentsApi,
        DeploymentsApi, ClustersApi)

def str2bool(value):
      return {"True": True, "true": True}.get(value, False)

def get_authenticated_client(args):

  client = ApiClient(args.server)

  # Authenticate. This will start a session and store the cookie
  auth = AuthenticationApi(client)
  auth.login(Login(username=args.admin_username, password=args.admin_password))
  return client

def get_cm_host(client, environment_name, deployment_name):

  api = DeploymentsApi(client)

  cm_host = api.getRedacted(environment_name, deployment_name)

  return cm_host.managerInstance.properties['publicIpAddress']

def get_cluster_config(client, environment_name, deployment_name, cluster_name, private):

  api = ClustersApi(client)

  cluster_config = api.get(environment_name, deployment_name, cluster_name)

  # Return private ip or public ip of master node
  for instance in cluster_config.instances:
    if instance.virtualInstance.template.tags['group'] == 'master':
      if private:
        return instance.ipAddress
      else:
        return instance.properties['publicIpAddress']

def create_hdfs_dir(server, dirs = []):
  try:
    hdfs = PyWebHdfsClient(host=server,port='50070', user_name='hdfs', timeout=5)
  except Exception, e:
    print >> sys.stderr, "Exception: %s" % str(e)
    sys.exit(0)

  for dir in dirs:
    hdfs.make_dir(dir, permission=777)

def main():
  parser = argparse.ArgumentParser(prog='bootstrap_cdh.py')

  parser.add_argument('--admin-username', default="admin",
                      help='Name of an user with administrative access (defaults to %(default)s)')
  parser.add_argument('--admin-password', default="admin",
                      help='Password for the administrative user (defaults to %(default)s)')
  parser.add_argument('--server', default="http://localhost:7189",
                      help="Cloudera Director server URL (defaults to %(default)s)")
  parser.add_argument('--cluster', default="bigdatalab-cluster",
                      help="Cloudera cluster (defaults to %(default)s)")
  parser.add_argument('--deploy', default="False",
                      help="Deploy cluster (defaults to %(default)s)")
  args = parser.parse_args()


  cluster_name = args.cluster
  environment_name = cluster_name + ' Environment'
  deployment_name = cluster_name + ' Deployment'
  if str2bool(args.deploy):
    client = get_authenticated_client(args)
    namenode_private_ip = get_cluster_config(client, environment_name, deployment_name, cluster_name, private=True)

    # Directories to create on HDFS for Flume Collector
    flume_dir = [ 'flume', 'flume/logs', 'flume/logs/access', 'flume/logs/error' ]

    # Get Public IP address of Namenode 
    namenode_public_ip = get_cluster_config(client, environment_name, deployment_name, cluster_name, private=False)

    # Create directories on HDFS for Flume Collector
    create_hdfs_dir(namenode_public_ip, flume_dir)

    print namenode_private_ip


  return 0

if __name__ == '__main__':
  try:
    sys.exit(main())

  except HTTPError as e:
    print e.read()
    raise e
