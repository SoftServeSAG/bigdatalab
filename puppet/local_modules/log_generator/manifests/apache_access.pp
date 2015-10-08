class log_generator::apache_access (
  $install_dir      = undef,
  $sleep_from       = undef,
  $sleep_to         = undef,
  $flume_agent_host = undef,
  $flume_agent_port = undef,
  $rows_in_batch    = 1000,
  $service_enabled  = true
){

  # Validate parameters
  validate_absolute_path($install_dir)
  validate_integer($flume_agent_port)
  if !is_ip_address($flume_agent_host) {
    fail("${flume_agent_host} is not an ip address")
  }

  # Create systemd service file
  file { 'apache_access_log_generator.service':
    path    => "/lib/systemd/system/apache_access_log_generator.service",
    mode    => "0775",
    ensure  => file,
    replace => true,
    content => template('log_generator/apache_access_log_generator.service.erb'),
    require => File["${install_dir}"]
  } ->

  service { 'apache_access_log_generator':
    ensure    => running,
    enable    => $service_enabled,
    provider  => systemd
  }
}