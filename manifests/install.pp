class dell_omsa::install inherits ::dell_omsa {
  if $manage_install == true {
    notice("Managing Dell Software install for $::clientcert")
    #Make Sure OMSA is installed
    package { "$omsa_pkg":
      ensure  => "$omsa_ensure",
    }
  }
}
