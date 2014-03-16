class ldap::repo {
  yumrepo { 'ltb-project':
    baseurl   => "http://ltb-project.org/rpm/$operatingsystemmajrelease/$architecture",
    desc      => 'LTB project packages',
    enabled   => 1,
    gpgcheck  => 0,
  }
}
