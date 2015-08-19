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
  scp_to(host, hiera_root, '/etc/puppetlabs')
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

    #hosts.each do |host|
      #on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
    #end
  end
end