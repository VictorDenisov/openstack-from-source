stage { 'first':
	before => Stage['main'],
}

class { 'apt':
	always_apt_update => true,
	fancy_progress    => true,
	stage             => first,
}
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

package { 'python-mysqldb':
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

augeas { 'keystone-conf':
	lens    => 'Pythonpaste.lns',
	incl    => '/vagrant/keystone/etc/keystone.conf',
	changes => [ "set /files/vagrant/keystone/etc/keystone.conf/database/connection mysql://keystone_user:keystone_pass@${::mysql_ip}/keystone",
		     "set /files/vagrant/keystone/etc/keystone.conf/DEFAULT/admin_token ADMIN_TOKEN", ],
	require => File['keystone.conf'],
}

exec { 'keystone-start':
	command => '/vagrant/aux_scripts/start_keystone.sh',
	require => Augeas['keystone-conf'],
}
