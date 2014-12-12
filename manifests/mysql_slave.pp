stage { 'first':
	before => Stage['main'],
}

class { 'apt':
	always_apt_update => true,
	fancy_progress    => true,
	stage             => first,
}

$override_options = {
  'section' => {
    'item' => 'thing',
  }
}

class { '::mysql::server':
  root_password    => 'mysql_password',
  override_options => $override_options
}

class { '::mysql::client': }

exec { '/bin/hostname mysql-slave': }

file { '/etc/hostname':
	ensure  => file,
	content => 'mysql-slave',
	owner   => 'root',
	group   => 'root',
}
