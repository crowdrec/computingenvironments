	include apt



    # Install base packages
    $enhancers = [ "unzip", "git",  "libfile-slurp-perl", "mono-xbuild", "mono-gmcs" ]
    package { $enhancers: }

	apt::ppa { 'ppa:directhex/monoxide': 
	} ->
	package { ["mono-devel"]:
    	ensure => "installed"
	}
    
    #checkout mymedialite from repo
   	git::repo{'mymedialite':
 		path   => '/opt/mymedialite',
 		source => 'https://github.com/zenogantner/mymedialite'
	} ->

	 # Compile mymedialite
  	exec { "make all":
    	cwd        => '/opt/mymedialite',
    	creates => "/opt/mymedialite/lib/mymedialite/MyMediaLite.dll",
    	path => ["/usr/bin", "/usr/sbin", "/bin", "/sbin"],
    	timeout => 600
  	} ->

  	#checkout wraprec from repo
	git::repo{'wraprec':
 		path   => '/opt/wraprec',
 		source => 'https://github.com/babakx/WrapRec'
	} ->

	# build wraprec
	exec { "xbuild":
    	cwd        => '/opt/wraprec',
    	creates => "",
    	path => ["/usr/bin", "/usr/sbin", "/bin", "/sbin"],
    	timeout => 600
  	} 


  	