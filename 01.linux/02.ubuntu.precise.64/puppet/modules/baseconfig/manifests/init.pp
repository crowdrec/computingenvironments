# == Class: baseconfig
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class baseconfig {

	package { "openjdk-6-jdk":
    	ensure => "installed"
	}

}

