# == Class: jdk_oracle
#
# Installs the Oracle Java JDK, from the Oracle servers
#
# === Parameters
#
# [*version*]
#   String.  Java Version to install
#   Defaults to <tt>7</tt>.
#
# [* java_install_dir *]
#   String.  Java Installation Directory
#   Defaults to <tt>/opt</tt>.
#
# [* platform *]
#   String.  The platform to use
#   Defaults to <tt>x64</tt>.
#
#
class jdk_oracle(
    $ensure       = present,
    $version      = '7',
    $install_dir  = '/opt',
    $platform     = 'x64',
    ) {

    # Set default exec path for this module
    Exec { path    => ['/usr/bin', '/usr/sbin', '/bin'] }

    case $platform {
        'x64': {
            $plat_filename = 'x64'
        }
        'x86': {
            $plat_filename = 'i586'
        }
        default: {
            fail("Unsupported platform: ${platform}.  Implement me?")
        }
    }

    case $version {
        '8': {
            $javaDownloadURI = "http://download.oracle.com/otn-pub/java/jdk/8u5-b13/jdk-8u5-linux-${plat_filename}.rpm"
        }
        '7': {
            $javaDownloadURI = "http://download.oracle.com/otn-pub/java/jdk/7u60-b19/jdk-7u60-linux-${plat_filename}.rpm"
        }
        default: {
            fail("Unsupported version: ${version}.  Implement me?")
        }
    }

    $installerFilename = '/var/tmp/jdk.rpm'
    exec { 'download-jdk':
            cwd     => $install_dir,
            command => join([
              'wget -c --no-cookies --no-check-certificate',
                '--header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com"',
                '--header "Cookie: oraclelicense=accept-securebackup-cookie"',
                  "${javaDownloadURI} -O ${installerFilename}"], ' '),
            timeout => 600,
            require => Package['wget'],
            creates => '/var/tmp/jdk.rpm',
    }
    
    package { 'jdk':
      ensure   => installed,
      require  => Exec['download-jdk'],
      provider => rpm,
      source   => '/var/tmp/jdk.rpm'
    }
        
    $java_home = '/usr/java/default'

    file { '/etc/profile.d/java.sh':
        content => "export JAVA_HOME=${java_home}\nexport PATH=${java_home}/bin:\$PATH",
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        require => Package['jdk'],
    }

  case $::operatingsystem {
    'CentOS', 'RedHat', 'OEL', 'OracleLinux', 'SLES': {
      Exec {
        require =>  Package['jdk'],
      }

      # Remove the old config from previous module releases.
      exec { 'java-alternatives-old':
        command => 'alternatives --remove java /usr/java/default/jre/bin/java',
        onlyif  => 'alternatives --display java | grep -q /usr/java/default/jre/bin/java',
        require => Package['jdk'],
        returns => [ 0, 2, ],
      }

      # https://stackoverflow.com/questions/2701100/problem-changing-java-version-using-alternatives
      case $ensure {
        'present': {
          $java_alternatives = join([
            'alternatives --install /usr/bin/java java /usr/java/default/bin/java 1601',
            '--slave /usr/bin/keytool keytool /usr/java/default/bin/keytool',
            '--slave /usr/bin/orbd orbd /usr/java/default/bin/orbd',
            '--slave /usr/bin/pack200 pack200 /usr/java/default/bin/pack200',
            '--slave /usr/bin/rmid rmid /usr/java/default/bin/rmid',
            '--slave /usr/bin/rmiregistry rmiregistry /usr/java/default/bin/rmiregistry',
            '--slave /usr/bin/servertool servertool /usr/java/default/bin/servertool',
            '--slave /usr/bin/tnameserv tnameserv /usr/java/default/bin/tnameserv',
            '--slave /usr/bin/unpack200 unpack200 /usr/java/default/bin/unpack200',
            '--slave /usr/bin/ControlPanel ControlPanel /usr/java/default/bin/ControlPanel',
            '--slave /usr/bin/jcontrol jcontrol /usr/java/default/bin/jcontrol',
            '--slave /usr/share/man/man1/java.1 java.1.gz /usr/java/default/man/man1/java.1',
            '--slave /usr/share/man/man1/keytool.1 keytool.1.gz /usr/java/default/man/man1/keytool.1',
            '--slave /usr/share/man/man1/orbd.1 orbd.1.gz /usr/java/default/man/man1/orbd.1',
            '--slave /usr/share/man/man1/pack200.1 pack200.1.gz /usr/java/default/man/man1/pack200.1',
            '--slave /usr/share/man/man1/rmid.1 rmid.1.gz /usr/java/default/man/man1/rmid.1',
            '--slave /usr/share/man/man1/rmiregistry.1 rmiregistry.1.gz /usr/java/default/man/man1/rmiregistry.1',
            '--slave /usr/share/man/man1/servertool.1 servertool.1.gz /usr/java/default/man/man1/servertool.1',
            '--slave /usr/share/man/man1/tnameserv.1 tnameserv.1.gz /usr/java/default/man/man1/tnameserv.1',
            '--slave /usr/share/man/man1/unpack200.1 unpack200.1.gz /usr/java/default/man/man1/unpack200.1'], ' ')

          exec { 'java-alternatives':
            command =>  $java_alternatives,
            unless  => 'update-alternatives --display java | grep -q /usr/java/default/bin/java',
            require => Package['jdk'],
            returns => [ 0, 2, ],
          }
          
          $javac_alternatives = join(['alternatives --install /usr/bin/javac javac /usr/java/default/bin/javac 1601',
'--slave /usr/bin/appletviewer appletviewer /usr/java/default/bin/appletviewer',
'--slave /usr/bin/apt apt /usr/java/default/bin/apt',
'--slave /usr/bin/extcheck extcheck /usr/java/default/bin/extcheck',
'--slave /usr/bin/idlj idlj /usr/java/default/bin/idlj',
'--slave /usr/bin/jar jar /usr/java/default/bin/jar',
'--slave /usr/bin/jarsigner jarsigner /usr/java/default/bin/jarsigner',
'--slave /usr/bin/javadoc javadoc /usr/java/default/bin/javadoc',
'--slave /usr/bin/javah javah /usr/java/default/bin/javah',
'--slave /usr/bin/javap javap /usr/java/default/bin/javap',
'--slave /usr/bin/jconsole jconsole /usr/java/default/bin/jconsole',
'--slave /usr/bin/jdb jdb /usr/java/default/bin/jdb',
'--slave /usr/bin/jhat jhat /usr/java/default/bin/jhat',
'--slave /usr/bin/jinfo jinfo /usr/java/default/bin/jinfo',
'--slave /usr/bin/jmap jmap /usr/java/default/bin/jmap',
'--slave /usr/bin/jps jps /usr/java/default/bin/jps',
'--slave /usr/bin/jrunscript jrunscript /usr/java/default/bin/jrunscript',
'--slave /usr/bin/jsadebugd jsadebugd /usr/java/default/bin/jsadebugd',
'--slave /usr/bin/jstack jstack /usr/java/default/bin/jstack',
'--slave /usr/bin/jstat jstat /usr/java/default/bin/jstat',
'--slave /usr/bin/jstatd jstatd /usr/java/default/bin/jstatd',
'--slave /usr/bin/native2ascii native2ascii /usr/java/default/bin/native2ascii',
'--slave /usr/bin/policytool policytool /usr/java/default/bin/policytool',
'--slave /usr/bin/rmic rmic /usr/java/default/bin/rmic',
'--slave /usr/bin/schemagen schemagen /usr/java/default/bin/schemagen',
'--slave /usr/bin/serialver serialver /usr/java/default/bin/serialver',
'--slave /usr/bin/wsgen wsgen /usr/java/default/bin/wsgen',
'--slave /usr/bin/wsimport wsimport /usr/java/default/bin/wsimport',
'--slave /usr/bin/xjc xjc /usr/java/default/bin/xjc',
'--slave /usr/bin/jvisualvm jvisualvm /usr/java/default/bin/jvisualvm',
'--slave /usr/bin/HtmlConverter HtmlConverter /usr/java/default/bin/HtmlConverter',
'--slave /usr/share/man/man1/appletviewer.1 appletviewer.1.gz /usr/java/default/man/man1/appletviewer.1',
'--slave /usr/share/man/man1/apt.1 apt.1.gz /usr/java/default/man/man1/apt.1',
'--slave /usr/share/man/man1/extcheck.1 extcheck.1.gz /usr/java/default/man/man1/extcheck.1',
'--slave /usr/share/man/man1/idlj.1 idlj.1.gz /usr/java/default/man/man1/idlj.1',
'--slave /usr/share/man/man1/jar.1 jar.1.gz /usr/java/default/man/man1/jar.1',
'--slave /usr/share/man/man1/jarsigner.1 jarsigner.1.gz /usr/java/default/man/man1/jarsigner.1',
'--slave /usr/share/man/man1/javac.1 javac.1.gz /usr/java/default/man/man1/javac.1',
'--slave /usr/share/man/man1/javadoc.1 javadoc.1.gz /usr/java/default/man/man1/javadoc.1',
'--slave /usr/share/man/man1/javah.1 javah.1.gz /usr/java/default/man/man1/javah.1',
'--slave /usr/share/man/man1/javap.1 javap.1.gz /usr/java/default/man/man1/javap.1',
'--slave /usr/share/man/man1/jconsole.1 jconsole.1.gz /usr/java/default/man/man1/jconsole.1',
'--slave /usr/share/man/man1/jdb.1 jdb.1.gz /usr/java/default/man/man1/jdb.1',
'--slave /usr/share/man/man1/jhat.1 jhat.1.gz /usr/java/default/man/man1/jhat.1',
'--slave /usr/share/man/man1/jinfo.1 jinfo.1.gz /usr/java/default/man/man1/jinfo.1',
'--slave /usr/share/man/man1/jmap.1 jmap.1.gz /usr/java/default/man/man1/jmap.1',
'--slave /usr/share/man/man1/jps.1 jps.1.gz /usr/java/default/man/man1/jps.1',
'--slave /usr/share/man/man1/jrunscript.1 jrunscript.1.gz /usr/java/default/man/man1/jrunscript.1',
'--slave /usr/share/man/man1/jsadebugd.1 jsadebugd.1.gz /usr/java/default/man/man1/jsadebugd.1',
'--slave /usr/share/man/man1/jstack.1 jstack.1.gz /usr/java/default/man/man1/jstack.1',
'--slave /usr/share/man/man1/jstat.1 jstat.1.gz /usr/java/default/man/man1/jstat.1',
'--slave /usr/share/man/man1/jstatd.1 jstatd.1.gz /usr/java/default/man/man1/jstatd.1',
'--slave /usr/share/man/man1/native2ascii.1 native2ascii.1.gz /usr/java/default/man/man1/native2ascii.1',
'--slave /usr/share/man/man1/policytool.1 policytool.1.gz /usr/java/default/man/man1/policytool.1',
'--slave /usr/share/man/man1/rmic.1 rmic.1.gz /usr/java/default/man/man1/rmic.1',
'--slave /usr/share/man/man1/schemagen.1 schemagen.1.gz /usr/java/default/man/man1/schemagen.1',
'--slave /usr/share/man/man1/serialver.1 serialver.1.gz /usr/java/default/man/man1/serialver.1',
'--slave /usr/share/man/man1/wsgen.1 wsgen.1.gz /usr/java/default/man/man1/wsgen.1',
'--slave /usr/share/man/man1/wsimport.1 wsimport.1.gz /usr/java/default/man/man1/wsimport.1',
'--slave /usr/share/man/man1/xjc.1 xjc.1.gz /usr/java/default/man/man1/xjc.1',
'--slave /usr/share/man/man1/jvisualvm.1 jvisualvm.1.gz /usr/java/default/man/man1/jvisualvm.1',
'--slave /usr/lib/jvm/java java_sdk /usr/java/default',
'--slave /usr/lib/jvm-exports/java java_sdk_exports /usr/java/default/lib'],' ')

          exec { 'javac-alternatives':
            command => $javac_alternatives,
            unless  => 'alternatives --display javac | grep -q /usr/java/default/bin/javac',
            require => Package['jdk'],
            returns => [ 0, 2, ],
          }
        }
        'absent': {
          exec { 'java-alternatives':
            command => 'alternatives --remove java /usr/java/default/bin/java',
            onlyif  => 'alternatives --display java | grep -q /usr/java/default/bin/java',
            before  => Package['jdk'],
            returns => [ 0, 2, ],
          }

          exec { 'javac-alternatives':
            command => 'alternatives --remove javac /usr/java/default/bin/javac',
            onlyif  => 'alternatives --display javac | grep -q /usr/java/default/bin/javac',
            before  => Package['jdk'],
            returns => [ 0, 2, ],
          }

          exec { 'javaplugin-alternatives':
            command => 'alternatives --remove libjavaplugin.so.x86_64 /usr/java/default/jre/lib/amd64/libnpjp2.so',
            onlyif  => 'alternatives --display libjavaplugin.so.x86_64 | grep -q /usr/java/default/jre/lib/amd64/libnpjp2.so',
            before  => Package['jdk'],
            returns => [ 0, 2, ],
          }
        }
        default: { }
      }
    }
    default: { }
  }
}