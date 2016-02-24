node default {
    class {'roles::log_generator':}
    class {'roles::flume_agent':}
    class {'roles::flume_collector':}
}
