# Class to install flume collector role
class flume::collector($sources = [], $sinks = [], $channels = []) {
    $flume_lib  = '/usr/lib/flume/lib'
    $elk_version  = hiera('profiles::elasticsearch::es_version', '1.7.1')
    $lucene_core_version = hiera('profiles::elasticsearch::lucene_core_version', '4.10.4')

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

    file { "${flume_lib}/geoIpInterceptor.jar":
        source  => 'puppet:///modules/flume/geoIpInterceptor.jar',
        owner   => 'root',
        group   => 'root',
        ensure  => present,
    }

    package { 'GeoIP':
        ensure  => latest,
    }

    file { '/etc/GeoIP.conf':
        content => template('flume/GeoIP.conf'),
        require => Package['GeoIP'],
    }

    # Added pipe echo $? without this in Puppet geoipupdate returns 1
    exec { 'geoipupdate | echo $?':
        path => '/usr/bin',
        require => File['/etc/GeoIP.conf'],
    }

    file { '/etc/flume/conf/flume-collector.conf':
        content => template('flume/flume.conf'),
        require => Package['flume-agent'],
    }
}
