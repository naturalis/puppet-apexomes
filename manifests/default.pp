# update the $PATH environment variable
Exec {
	path => [
		"/usr/local/sbin",
		"/usr/local/bin",
		"/usr/sbin",
		"/usr/bin",
		"/sbin",
		"/bin",
	] 
}

class install {

	# keep package information up to date
	exec {
		"apt_update": command => "/usr/bin/apt-get update"
	}

	# install packages.
	package {
		"git":        ensure => installed, require => Exec ["apt_update"];
		"make":       ensure => installed, require => Exec ["apt_update"];
		"gcc":        ensure => installed, require => Exec ["apt_update"];
		"zlib1g-dev": ensure => installed, require => Exec ["apt_update"];
		"python-pip": ensure => installed, require => Exec ["apt_update"];
		"python-dev": ensure => installed, require => Exec ["apt_update"];
		"bwa":        ensure => installed, require => Exec ["apt_update"];
		"samtools":   ensure => installed, require => Exec ["apt_update"];
		"cmake":      ensure => installed, require => Exec ["apt_update"];
	}
  
	# additional install tasks
	exec {
		
		# install the sickle trimmer tool
		"sickle-clone":
			command => "git clone https://github.com/najoshi/sickle.git",
			cwd     => "/usr/local/src",
			creates => "/usr/local/src/sickle/Makefile",
			require => Package["git", "make"];
		"sickle-make":
			command => "make",
			cwd     => "/usr/local/src/sickle",
			creates => "/usr/local/src/sickle/sickle",
			require => Exec["sickle-clone"];
		"sickle-symlink":
			command => "ln -s /usr/local/src/sickle/sickle /usr/local/bin/sickle",
			cwd     => "/usr/local/src/sickle",
			creates => "/usr/local/bin/sickle",
			require => Exec["sickle-make"];
			
		# install pip packages
		"pip-packages":
			command => "pip install ftp-cloudfs python-keystoneclient python-swiftclient",
			require => Package["python-pip"];
		
		# clone freebayes
		"freebayes-clone":
			command => "git clone --recursive https://github.com/ekg/freebayes.git",
			cwd     => "/usr/local/src",
			creates => "/usr/local/src/freebayes/Makefile",
			require => Package["git", "make", "cmake"];
		"freebayes-make":
			command => "make install",
			cwd     => "/usr/local/src/freebayes",
			creates => "/usr/local/bin/freebayes",
			require => Exec["freebayes-clone"];
		
		# clone apexomes
		"apexomes-clone":
			command => "git clone https://github.com/naturalis/apexomes.git",
			cwd     => "/home/ubuntu",
			creates => "/home/ubuntu/apexomes",
			require => Package["git"];
	}
}

class { 'install':
	stage => main,
}
