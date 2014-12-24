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

exec { '/bin/hostname glance': }

file { '/etc/hostname':
	ensure  => file,
	content => "glance",
	owner   => 'root',
	group   => 'root',
}

vcsrepo { "/vagrant/glance":
	ensure   => present,
	provider => git,
	source   => "https://github.com/openstack/glance.git",
	revision => "2014.2",
	require => [Package['git']],
}

package { 'python-pip':
	ensure => present,
}
package { 'python-dev':
	ensure => present,
}

apt::builddep { 'glance': }

package { 'python-mysqldb':
	ensure => present,
}

exec { 'requirements':
	command => '/usr/bin/pip install -r /vagrant/glance/requirements.txt',
	require => [Apt::Builddep['glance'],
	            Package['python-pip'],
		    Package['python-dev'],
		    Vcsrepo['/vagrant/glance'],
		    ],
}

exec { 'glance-install':
	command => '/vagrant/glance_install.sh',
	require => [Exec['requirements']],
}

#file { 'keystone.conf':
#	path   => '/vagrant/keystone/etc/keystone.conf',
#	source => 'file:///vagrant/keystone/etc/keystone.conf.sample',
#}

#augeas { 'keystone-conf':
#	lens    => 'Pythonpaste.lns',
#	incl    => '/vagrant/keystone/etc/keystone.conf',
#	changes => [ "set /files/vagrant/keystone/etc/keystone.conf/database/connection mysql://keystone_user:keystone_pass@${::mysql_ip}/keystone",
#		     "set /files/vagrant/keystone/etc/keystone.conf/DEFAULT/admin_token ADMIN_TOKEN", ],
#	require => File['keystone.conf'],
#}
