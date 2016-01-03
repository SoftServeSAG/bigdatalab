require 'spec_helper'
require 'hiera'

describe 'flume::agent' do

  it do
    should contain_package('flume-agent').with(
      'ensure' => 'latest'
  ) end

  it { should contain_file('/etc/flume/conf/flume-agent.conf') }

  it do
    should contain_service('flume-agent').with(
      'ensure' => 'running',
      'hasstatus' => 'true',
      'hasrestart' => 'true',
      'require' => [ 'Package[flume-agent]', 'File[/etc/flume/conf/flume-agent.conf]' ],
      'subscribe' => 'File[/etc/flume/conf/flume-agent.conf]'
   ) end

  at_exit { RSpec::Puppet::Coverage.report! }

end

describe 'flume::collector' do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  hiera = Hiera.new(:config => 'spec/fixtures/hiera/hiera.yaml')
#  scope = YAML.load_file('spec/fixtures/hiera/common.yaml').values
#  $elk_version = '2.0.0'
  $lucene_version = '5.2.1'
  $elk_version = hiera.lookup('profiles::elasticsearch::es_version', nil, 'common')
  it do
    should contain_package('flume-agent').with(
      'ensure' => 'latest'
  ) end

  it { should contain_file('/etc/flume/conf/flume-collector.conf') }

  it 'should generate valid content for flume-collector.conf' do
    content = catalogue.resource('file', '/etc/flume/conf/flume-collector.conf').send(:parameters)[:content]
    content.should_not be_empty
  end

  it do
    should contain_maven('/usr/lib/flume/lib/elasticsearch.jar').with(
      'groupid' => 'org.elasticsearch',
      'artifactid' => 'elasticsearch',
      'version' => $elk_version
  ) end

  it do
    should contain_maven('/usr/lib/flume/lib/lucene-core.jar').with(
      'groupid' => 'org.apache.lucene',
      'artifactid' => 'lucene-core',
      'version' => $lucene_version
  ) end

 it do
    should contain_service('flume-agent').with(
      'ensure' => 'running',
      'require' => [ 'Package[flume-agent]', 'File[/etc/flume/conf/flume-collector.conf]', 'Maven[/usr/lib/flume/lib/elasticsearch.jar]' ],
      'subscribe' => [ 'File[/etc/flume/conf/flume-collector.conf]', 'Maven[/usr/lib/flume/lib/elasticsearch.jar]' ],
      'hasstatus' => 'true',
      'hasrestart' => 'true'
   ) end

  at_exit { RSpec::Puppet::Coverage.report! }

end
