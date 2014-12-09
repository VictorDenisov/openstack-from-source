exec { '/usr/bin/apt-get update': }

package { 'git':
	ensure => present,
}

exec { '/bin/hostname keystone': }

file { '/etc/hostname':
	ensure  => file,
	content => "keystone",
	owner   => 'root',
	group   => 'root',
}

package { ['python-dev', 'libxml2-dev', 'libxslt1-dev', 'libsasl2-dev', 'libsqlite3-dev', 'libssl-dev', 'libldap2-dev', 'libffi-dev']:
	ensure => present,
}
