#
# Common profile for all linux servers.
# Currently supports only RedHat flavors due to explicit yum and selinux usage.
#

class profiles::linux inherits profiles::common {

  # Initialize hiera variables
  $supported_oss = hiera('profiles::linux::supported_oss')
  $repo_timeout  = hiera('profiles::linux::repo_timeout')
  $exec_path     = hiera('profiles::linux::exec_path')

  # Validate values
  validate_hash($supported_oss)
  validate_integer($repo_timeout)
  validate_array($exec_path)


  # Check OS
  $os = $::facts['operatingsystem']
  if !has_key($supported_oss, $os) {
    fail("${os} is not supported")
  }


  # Check OS version
  $os_version = $::facts['operatingsystemrelease']
  $supported_os_versions = $supported_oss[$os]
  validate_array($supported_os_versions)
  
  if !member($supported_os_versions, $os_version) {
    fail("Version ${os_version} of ${os} is not supported")
  }


  # General system settings
  Exec { path => $exec_path }

  class { '::selinux':
    mode => 'disabled'
  }


  # Set up repositories
  class { '::yumrepo':
    timeout => $repo_timeout
  }


  # Install and configure vital packages
  package { 'wget':
    ensure => present
  }

  class { '::ntp': }
  class { '::jdk_oracle': }

}