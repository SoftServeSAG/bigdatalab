class log_generator::vmstat (
  $install_dir      = undef,
  $flume_agent_host = undef,
  $flume_agent_port = undef,
  $service_enabled  = true
){

  # Validate parameters
  validate_absolute_path($install_dir)
  validate_integer($flume_agent_port)
  if !is_ip_address($flume_agent_host) {
    fail("${flume_agent_host} is not an ip address")
  }

  # Create systemd service file
  file { 'vmstat_log_generator.service':
    path    => "/lib/systemd/system/vmstat_log_generator.service",
    mode    => "0775",
    ensure  => file,
    replace => true,
    content => template('log_generator/vmstat_log_generator.service.erb'),
    require => File["${install_dir}"]
  } ->

  service { 'vmstat_log_generator':
    ensure    => running,
    enable    => $service_enabled,
    provider  => systemd
  }
}