class log_generator (

  $install_dir                    = '/var/lib/log_generator',
  $apache_access_flume_agent_host = hiera( 'profiles::log_generator::flume_agent_node', '127.0.0.1' ),
  $apache_access_flume_agent_port = 5001,
  $apache_access_sleep_from       = 0,
  $apache_access_sleep_to         = 5,
  $apache_access_rows_in_batch    = 1000,
  $apache_access_enabled          = true,

  $apache_error_flume_agent_host  = hiera( 'profiles::log_generator::flume_agent_node', '127.0.0.1' ),
  $apache_error_flume_agent_port  = 5002,
  $apache_error_sleep_from        = 10,
  $apache_error_sleep_to          = 20,
  $apache_error_rows_in_batch     = 10,
  $apache_error_enabled           = true,

  $iostat_flume_agent_host        = '127.0.0.1',
  $iostat_flume_agent_port        = 33302,
  $iostat_enabled                 = true,

  $vmstat_flume_agent_host        = '127.0.0.1',
  $vmstat_flume_agent_port        = 33303,
  $vmstat_enabled                 = true
) {

  class { '::log_generator::environment':
    home_dir => $install_dir
  } ->

  class { '::log_generator::apache_access':
    install_dir       => $install_dir,
    sleep_from        => $apache_access_sleep_from,
    sleep_to          => $apache_access_sleep_to,
    rows_in_batch     => $apache_access_rows_in_batch,
    flume_agent_host  => $apache_access_flume_agent_host,
    flume_agent_port  => $apache_access_flume_agent_port,
    service_enabled   => $apache_access_enabled
  }

  class { '::log_generator::apache_error':
    install_dir       => $install_dir,
    sleep_from        => $apache_error_sleep_from,
    sleep_to          => $apache_error_sleep_to,
    rows_in_batch     => $apache_error_rows_in_batch,
    flume_agent_host  => $apache_error_flume_agent_host,
    flume_agent_port  => $apache_error_flume_agent_port,
    service_enabled   => $apache_error_enabled
  }

  class { '::log_generator::iostat':
    install_dir       => $install_dir,
    flume_agent_host  => $iostat_flume_agent_host,
    flume_agent_port  => $iostat_flume_agent_port,
    service_enabled   => $iostat_enabled
  }

  class { '::log_generator::vmstat':
    install_dir       => $install_dir,
    flume_agent_host  => $vmstat_flume_agent_host,
    flume_agent_port  => $vmstat_flume_agent_port,
    service_enabled   => $vmstat_enabled
  }
}
