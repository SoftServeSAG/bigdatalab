node default {
    class {'roles::flume_agent':}
    class {'roles::flume_collector':}
}
