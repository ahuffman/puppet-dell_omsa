class dell_omsa::service inherits ::dell_omsa {
  if $manage_services == true {
    notice("Managing Dell Services for $::clientcert")
    #Make Sure OMSA Services startup on boot and are running
    service { $omsa_svcs:
      ensure  => 'running',
      enable  => true,
    }
  }
}
