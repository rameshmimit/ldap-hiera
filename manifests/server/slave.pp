class ldap::server::slave(
  $suffix              = hiera('suffix'),
  $rootpw              = hiera('rootpw'),
  $rootdn              = hiera('rootdn'),
  $schema_inc          = hiera_array('schema_inc'),
  $modules_inc         = hiera('modules_inc'),
  $index_inc           = hiera_hash('index_inc'),
  $log_level           = hiera('loglevel'),
  $enable_motd         = hiera('enable_motd'),
  $sync_rid            = hiera('sync_rid'),
  $sync_provider       = hiera('sync_provider'),
  $sync_updatedn       = hiera('sync_updatedn'),
  $sync_binddn         = hiera('sync_binddn'),
  $sync_bindpw         = hiera('sync_bindpw'),
  $syncprov            = hiera('syncprov'),
  $syncprov_checkpoint = hiera_arrya('syncprov_checkpoint'),
  $syncprov_sessionlog = hiera('syncprov_sessionlog'),
  $sync_binddn         = hiera('sync_binddn'),
  $sync_base           = hiera('sync_base'),
  $sync_type           = 'refreshOnly',
  $sync_interval       = '00:00:10:00',
  $sync_filter         = '(objectClass=*)',
  $sync_attrs          = '*',
  $sync_scope          = 'sub',
  $bind_anon           = true,
  $ensure              = present) {

  include ldap::params
  include ldap::repo

  package { $ldap::params::server_package:
    ensure => installed,
  }

  service { $ldap::params::service:
    ensure     => running,
    enable     => true,
    pattern    => $ldap::params::server_pattern,
    require    => [
      Package[$ldap::params::server_package],
      File["${ldap::params::prefix}/${ldap::params::server_config}"],
      ],
  }

  file { "${ldap::params::prefix}/${ldap::params::server_config}":
    ensure  => present,
    content => template("ldap/${ldap::params::server_config}.erb"),
    notify  => Service[$ldap::params::service],
    require => Package[$ldap::params::server_package],
  }

  exec { 'slaptest':
    command   => 'slaptest -u',
    subscribe => File[ "${ldap::params::prefix}/${ldap::params::server_config}" ],
    require   => Package[ "$ldap::params::server_package" ],
  }

  file { "$ldap::params::db_prefix/DB_CONFIG":
    ensure  => $ensure,
    source  => template("ldap/DB_CONFIG.erb"),
    require => Package[$ldap::params::server_package],
  }
}
