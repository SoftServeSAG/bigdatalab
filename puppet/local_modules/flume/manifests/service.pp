# Class to manage flume-agent service
class flume::service() {
    service { 'flume-agent':
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
    }
}
