require 'beaker-rspec'
require 'pry'

project_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
modules_root = File.join(project_root, 'modules')
hiera_root = File.join(project_root, 'hiera')


hosts.each do |host|
  # Install Puppet
  shell('sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm')
  on host, install_puppet

  # Copy hiera data
  scp_to(host, File.join(hiera_root, 'hiera.yaml'), '/etc/puppetlabs/code')
  scp_to(host, File.join(hiera_root, 'hieradata'), '/etc/puppetlabs/code')
end

RSpec.configure do |c|
  modules_root = File.expand_path(File.join(File.dirname(__FILE__), '../modules'))
  modules = (Dir.entries(modules_root) - ['.', '..', 'fixtures'])

  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do  

    # Install modules
    modules.each do |m|
      module_path = File.join(modules_root, m)
      puppet_module_install(:source => module_path, :module_name => m)
    end

  end
end