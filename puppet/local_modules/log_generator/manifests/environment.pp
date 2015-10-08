class log_generator::environment (
  $home_dir = undef,
){

  validate_absolute_path($home_dir)

  package { 'ruby':
    ensure => present
  }

  package { 'nc':
    ensure => present
  }

  package { 'sysstat': 
    ensure => present
  }

  group { 'log_generator':
    ensure => present,
    gid    => 1100
  }

  user { 'log_generator': 
    gid   => 'log_generator',
    home  => $home_dir,
    shell => '/sbin/nologin'
  }

  file { 'log_generator_home':
    name    => $home_dir,
    ensure  => directory,
    owner   => 'log_generator',
    group   => 'log_generator',
    mode    => '775',    
    source  => 'puppet:///modules/log_generator',
    recurse => true
  }
}