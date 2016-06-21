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
}
