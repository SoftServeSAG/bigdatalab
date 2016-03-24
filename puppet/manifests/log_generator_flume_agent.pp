node default {
    class {'roles::log_generator':}
    class {'roles::flume_agent':}
}
