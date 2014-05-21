
    # Install base packages
    $enhancers = [ "wget", "unzip", "git" ]
    package { $enhancers: }

	 # Disable SELinux
    class { 'selinux':
        mode => 'disabled'
    }
    
    # Disable iptables
    class { 'firewall':
        ensure => 'stopped'
    }

    # Install java
    class { 'jdk_oracle':
      version => '6',
      install_dir => '/opt/'
    }
    file { '/opt/java':
      ensure => 'link',
      target => '/opt/java_home'
    }



  # Install Maven
  class { "maven::maven":
    require => "
    version => "3.2.1", # version to install
    require => File['/opt/java']
    # you can get Maven tarball from a Maven repository instead than from Apache servers, optionally with a user/password
    repo => {
      #url => "http://repo.maven.apache.org/maven2",
      #username => "",
      #password => "",
    }
  } 

  # Compile algorithm
  exec { "mvn clean compile assembly:single":
    cwd        => '/mnt/algo',
    require => Package['maven::maven']
    creates => "/mnt/algo/target/crowdrec-mahout-test-1.0-SNAPSHOT-jar-with-dependencies.jar",
    path => ["/usr/bin", "/usr/sbin", "/bin", "/sbin"]
  }

  # Execute algorithm
  exec { "java -cp target/crowdrec-mahout-test-1.0-SNAPSHOT-jar-with-dependencies.jar dev.crowdrec.recs.mahout.ItembasedRec_batch /tmp /mnt/messaging/msg":
    require => File['/mnt/algo/target/crowdrec-mahout-test-1.0-SNAPSHOT-jar-with-dependencies.jar'],
    cwd        => '/mnt/algo',
    path => ["/usr/bin", "/usr/sbin", "/bin", "/sbin"]
  }

