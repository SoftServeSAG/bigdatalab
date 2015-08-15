require 'rspec-puppet'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(Dir.pwd, '.modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.environmentpath = File.join(Dir.pwd, 'spec')
  c.hiera_config = File.join(Dir.pwd, 'spec/hiera/hiera.yaml')
  c.default_facts = {
    :operatingsystem        => 'CentOS', 
    :operatingsystemrelease => '7.0', 
    :osfamily               => 'RedHat'
  }
end
