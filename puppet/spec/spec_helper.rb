require 'rspec-puppet'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(Dir.pwd, 'modules')
  puts "MODULE_PATH: #{c.module_path}"
  c.manifest_dir = File.join(fixture_path, 'manifests')
  puts "MANIFEST_DIR: #{c.manifest_dir}"
  c.environmentpath = File.join(Dir.pwd, 'spec')
  puts "ENVIRONMENTPATH: #{c.environmentpath}"
  c.hiera_config = File.join(Dir.pwd, 'spec/hiera/hiera.yaml')
  puts "HIERA_CONFIG: #{c.hiera_config}"
  c.default_facts = {
    :operatingsystem        => 'CentOS', 
    :operatingsystemrelease => '7.0', 
    :osfamily               => 'RedHat'
  }
end
