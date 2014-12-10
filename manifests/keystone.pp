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

vcsrepo { "/vagrant/keystone":
	ensure   => present,
	provider => git,
	source   => "https://github.com/openstack/keystone.git",
	revision => "2014.2",
	before   => [Package['python-pip'], File['keystone.conf']],
}

package { 'python-pip':
	ensure => present,
	before => Exec['requirements'],
}

exec { 'requirements':
	command => '/usr/bin/pip install -r /vagrant/keystone/requirements.txt',
}

file { 'keystone.conf':
	path   => '/vagrant/keystone/etc/keystone.conf',
	source => 'file:///vagrant/keystone/etc/keystone.conf.sample',
}
