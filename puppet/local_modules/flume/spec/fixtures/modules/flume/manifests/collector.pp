# Class to install flume collector role
class flume::collector($sources = [], $sinks = [], $channels = []) {
    $flume_lib  = '/usr/lib/flume/lib'
    $elk_version  = hiera('profiles::elasticsearch::es_version', '1.7.1')
    $lucene_core_version = hiera('profiles::elasticsearch::lucene_core_version', '5.2.1')

    package { 'flume-agent':
        ensure => latest,
    }

    maven { "${flume_lib}/elasticsearch.jar":
        groupid    => 'org.elasticsearch',
        artifactid => 'elasticsearch',
        version    =>  $elk_version,
    }

    maven { "${flume_lib}/lucene-core.jar":
        groupid    => 'org.apache.lucene',
        artifactid => 'lucene-core',
        version    => $lucene_core_version,
    }

    file { '/etc/flume/conf/flume-collector.conf':
        content => template('flume/flume.conf'),
        require => Package['flume-agent'],
    }

    service { 'flume-agent':
        ensure     => running,
        require    => [Package['flume-agent'], File['/etc/flume/conf/flume-collector.conf'], Maven["${flume_lib}/elasticsearch.jar"]],
        subscribe  => [File['/etc/flume/conf/flume-collector.conf'], Maven["${flume_lib}/elasticsearch.jar"]],
        hasstatus  => true,
        hasrestart => true,
    }
}
