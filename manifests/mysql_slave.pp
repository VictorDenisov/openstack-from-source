stage { 'first':
	before => Stage['main'],
}

class { 'apt':
	always_apt_update => true,
	fancy_progress    => true,
	stage             => first,
}

$override_options = {
  'mysqld'         => {
    'server-id'    => 2,
    'bind-address' => $ip,
    'log_bin'      => '/var/log/mysql/mysql-bin.log',
    'relay-log'    => '/var/log/mysql/mysql-relay-bin.log',
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
	  }

  },
}

class { '::mysql::client': }

exec { '/bin/hostname mysql-slave': }

file { '/etc/hostname':
	ensure  => file,
	content => 'mysql-slave',
	owner   => 'root',
	group   => 'root',
}
