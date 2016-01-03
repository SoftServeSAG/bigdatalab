# Class to instal flume agent role
class flume::agent($sources = [], $sinks = [], $channels = []) {
    package { 'flume-agent':
        ensure  => latest,
    }

    file { '/etc/flume/conf/flume-agent.conf':
        content => template('flume/flume.conf'),
        require => Package['flume-agent'],
    }

    file { '/etc/flume/conf/flume.conf':
        ensure  => absent
    }

    service { 'flume-agent':
        ensure     => running,
        require    => [Package['flume-agent'], File['/etc/flume/conf/flume-agent.conf']],
        subscribe  => File['/etc/flume/conf/flume-agent.conf'],
        hasstatus  => true,
        hasrestart => true,
    }
}
