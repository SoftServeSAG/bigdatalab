# Class to instal flume agent role
class flume::agent($sources = [], $sinks = [], $channels = []) {
    file { '/etc/flume/conf/flume-agent.conf':
        content => template('flume/flume.conf'),
        require => Package['flume-agent'],
    }
}
