class ldap::params {
  case $::osfamily {
    'RedHat':  {
      $package         = hiera_array('package')
      $prefix          = hiera('prefix')
      $config          = hiera('config')
      $owner           = hiera('owner')
      $group           = hiera('group')
      $service         = hiera('service')
      $schema_base     = hiera_array('schema_base')
      $schema_prefix   = hiera('schema_prefix')
      $server_pattern  = hiera('server_pattern')
      $server_package  = hiera_array('server_package')
      $server_config   = hiera('server_config')
      $server_owner    = hiera('server_owner')
      $server_group    = hiera('server_group')
      $db_prefix       = hiera('db_prefix')
      $ssl_prefix      = hiera('ssl_prefix')
      $server_run      = hiera('server_run')
      $index_base      = hiera('index_base')
      $modules_base    = hiera('modules_base')
      $ltb_repo        = hiera('ltb_repo')

      case $::architecture {3
        /^amd64/: {
        $module_prefix = '/usr/lib64/ldap'
      }

        /^i?[36]86/: {
        $module_prefix = '/usr/lib/ldap'
      }

      default: {
        fail("Architecture not supported (${::architecture})")
      }
     }
   }
  }
}
