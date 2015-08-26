# == Class: profiles::linux
#
# Common profile for all linux servers.
# Currently supports only RedHat flavors due to explicit yum and selinux usage.
#
# === Parameters (Hiera)
#
# [* supported_oss *]
#   Hash of <String, String[]>.  OS support information.
#   OS as Hash key and list of corresponding versions as a hash value
#
# [* repo_timeout *]
#   Integer.  Timeout for yumrepo.
#
# [* exec_path *]
#   String[].  List of exec paths
#

class profiles::linux (
    $supported_oss,
    $repo_timeout = 300,
    $exec_path = ['/bin', '/sbin', '/usr/bin', '/usr/sbin']) {

  require profiles::common

  # Validate values
  validate_hash($supported_oss)
  validate_integer($repo_timeout)
  validate_array($exec_path)


  # Check OS
  $os = $::operatingsystem
  if !has_key($supported_oss, $os) {
    fail("${os} is not supported")
  }


  # Check OS version
  $os_version = $::operatingsystemmajrelease
  $supported_os_versions = $supported_oss[$os]
  validate_array($supported_os_versions)
  
  if !member($supported_os_versions, $os_version) {
    fail("Version ${os_version} of ${os} is not supported")
  }


  # General system settings
  Exec { path => $exec_path }
  Yumrepo { timeout => $repo_timeout }

  class { '::selinux':
    mode => 'disabled'
  }


  # Set up puppetlabs repository
  yumrepo { 'puppetlabs':
    baseurl  => "http://yum.puppetlabs.com/el/${$os_version}/products/x86_64/",
    descr    => 'PuppetLabs official yum repository',
    enabled  => 1,
    gpgcheck => 0,
    gpgkey   => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs'
  }


  # Install and configure vital packages
  package { 'wget':
    ensure => present
  }

  class { '::ntp': }
  class { '::jdk_oracle': }

}
