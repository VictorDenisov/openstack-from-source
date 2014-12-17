stage { 'first':
	before => Stage['main'],
}

class { 'apt':
	always_apt_update => true,
	fancy_progress    => true,
	stage             => first,
}

$override_options = {
  'mysqld' => {
    'bind-address' => $ip,
    'server-id'    => 1,
    'log_bin'      => '/var/log/mysql/mysql-bin.log',
    'binlog_do_db' => 'keystone',
  }
}

class { '::mysql::server':
  root_password    => 'mysql_password',
  override_options => $override_options,
  databases        => {
	  'keystone' => {
		  'ensure'  => 'present',
		  'charset' => 'utf8',
	  },
  },
  grants           => {
	  'keystone_user@localhost/keystone.*' => {
		  ensure     => 'present',
		  options    => ['GRANT'],
		  privileges => ['ALL'],
		  table      => ['keystone.*'],
		  user       => ['keystone_user@localhost'],
	  },
	  'keystone_user@%/keystone.*' => {
		  ensure     => 'present',
		  options    => ['GRANT'],
		  privileges => ['ALL'],
		  table      => ['keystone.*'],
		  user       => ['keystone_user@%'],
	  },
  },
  users                      => {
	  'keystone_user@localhost' => {
		  ensure                   => present,
		  password_hash            => '*8D713EFB625D51B3BFB9837108F7E2232EAEC017', # keystone_pass
	  },
	  'keystone_user@%' => {
		  ensure                   => present,
		  password_hash            => '*8D713EFB625D51B3BFB9837108F7E2232EAEC017', # keystone_pass
	  },
  },
  restart => true,
}

class { '::mysql::client': }

exec { '/bin/hostname mysql-master': }

file { '/etc/hostname':
	ensure  => file,
	content => 'mysql-master',
	owner   => 'root',
	group   => 'root',
}
