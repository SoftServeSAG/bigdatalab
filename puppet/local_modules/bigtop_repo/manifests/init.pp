class bigtop_repo() {


    case $operatingsystem {
        /(OracleLinux|Amazon|CentOS|Fedora|RedHat)/: {
            $default_yumrepo = "http://bigtop-repos.s3.amazonaws.com/releases/1.0.0/centos/$::operatingsystemmajrelease/x86_64"
            yumrepo { "Bigtop":
                baseurl => hiera("bigtop::bigtop_repo_uri", $default_yumrepo),
                descr => "Bigtop packages",
                enabled => 1,
                gpgcheck => 0,
            }
        }
        default: {
            notify{"WARNING: running on a neither yum nor apt platform -- make sure Bigtop repo is setup": }
        }
    }
}
