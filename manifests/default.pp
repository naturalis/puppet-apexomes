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
		"unzip":      ensure => installed, require => Exec ["apt_update"];
		"wget":       ensure => installed, require => Exec ["apt_update"];
	}
  
	# additional install tasks
	exec {
		
		# install the sickle trimmer tool
		"sickle-wget":
			command => "wget https://github.com/najoshi/sickle/archive/v1.33.zip",
			cwd     => "/usr/local/src",
			creates => "/usr/local/src/sickle-1.33.zip",
			require => Package["wget", "unzip", "make", "zlib1g-dev"];
		"sickle-unzip":
			command => "unzip sickle-1.33.zip",
			cwd     => "/usr/local/src",
			creates => "/usr/local/src/sickle-1.33/Makefile",
			require => Exec["sickle-wget"];
		"sickle-make":
			command => "make",
			cwd     => "/usr/local/src/sickle-1.33",
			creates => "/usr/local/src/sickle-1.33/sickle",
			require => Exec["sickle-unzip"];
		"sickle-symlink":
			command => "ln -s /usr/local/src/sickle-1.33/sickle /usr/local/bin/sickle",
			cwd     => "/usr/local/src/sickle-1.33",
			creates => "/usr/local/bin/sickle",
			require => Exec["sickle-make"];
			
		# install pip packages
		"pip-packages":
			command => "pip install ftp-cloudfs python-keystoneclient python-swiftclient",
			require => Package["python-pip", "python-dev"];
		
		# install freebayes
		"freebayes-wget":
			command => "wget https://github.com/ekg/freebayes/archive/v1.0.2.zip",
			cwd     => "/usr/local/src",
			creates => "/usr/local/src/freebayes-1.0.2.zip",
			require => Package["make", "cmake", "wget", "unzip"];
		"freebayes-unzip":
			command => "unzip freebayes-1.0.2.zip",
			cwd     => "/usr/local/src",
			creates => "/usr/local/src/freebayes-1.0.2/Makefile",
			require => Exec["freebayes-wget"];
		"freebayes-make":
			command => "make",
			cwd     => "/usr/local/src/freebayes-1.0.2",
			creates => "/usr/local/src/freebayes-1.0.2/bin/freebayes",
			require => Exec["freebayes-unzip"];
		"freebayes-install":
			command => "make install",
			cwd     => "/usr/local/src/freebayes-1.0.2",
			creates => "/usr/local/bin/freebayes",
			require => Exec["freebayes-make"];
		
		# clone apexomes
		"apexomes-clone":
			command => "git clone https://github.com/naturalis/apexomes.git",
			cwd     => "/usr/local/src",
			creates => "/usr/local/src/apexomes",
			require => Package["git"];
	}
}

class { 'install':
	stage => main,
}
