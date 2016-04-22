# Class to instal flume-agent
class flume::install() {

    $heap_size = floor(($::memorysize_mb/2))

    package { 'flume-agent':
        ensure  => 1.5.2,
    }

    file { '/etc/flume/conf/flume.conf':
        ensure  => absent,
        require => Package['flume-agent']
    }

    file { 'flume-env':
        ensure  => present,
        path    => '/etc/flume/conf/flume-env.sh',
        require => Package['flume-agent']
    }

    file_line { 'flume-env':
        line    => "JAVA_OPTS=\"-Xms${heap_size}m -Xmx${heap_size}m -XX:-HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/java_pid<pid>.hprof -Dflume.monitoring.type=http -Dflume.monitoring.port=5653\"",
        path    => '/etc/flume/conf/flume-env.sh',
        require => File['flume-env']
    }
}
