class dell_omsa::config_drac_nic inherits ::dell_omsa {
  if $manage_drac_nic == true {
    #Manage DRAC Networking
    #Make sure we have a DRAC to manage
    if $::hasdrac == 1 {
      notice("Managing DRAC Network Interface Configuration for $::clientcert")
      if $drac_ip {
        exec { 'Set DRAC NIC - IP Address':
          command     => "racadm config -g cfgLanNetworking -o cfgNicIpAddress ${drac_ip}",
          path        => "$dell_path",
          timeout     => 1800,
          onlyif      => "test `racadm getconfig -g cfgLanNetworking -o cfgNicIpAddress` != ${drac_ip}",
        }
      }
      if $drac_netmask {
        exec { 'Set DRAC NIC - Netmask':
          command    => "racadm config -g cfgLanNetworking -o cfgNicNetmask ${drac_netmask}",
          path       => "$dell_path",
          timeout    => 1800,
          onlyif     => "test `racadm getconfig -g cfgLanNetworking -o cfgNicNetmask'` != ${drac_netmask}",
        }
      }

      if $drac_gateway {
        exec { 'Set DRAC NIC - Gateway':
          command    => "racadm config -g cfgLanNetworking -o cfgNicGateway ${drac_gateway}",
          path       => "$dell_path",
          timeout    => 1800,
          onlyif     => "test `racadm getconfig -g cfgLanNetworking -o cfgNicGateway'` != ${drac_gateway}",
        }
      }

      if $drac_dns1 {
        exec { 'Set DRAC NIC - DNS Server1':
          command   => "racadm config -g cfgLanNetworking -o cfgDNSServer1 ${drac_dns1}",
          path      => "$dell_path",
          timeout   => 1800,
          onlyif    => "test `racadm getconfig -g cfgLanNetworking -o cfgDNSServer1` != ${drac_dns1}",
        }
      }

      if $drac_dns2 {
        exec { 'Set DRAC NIC - DNS Server2':
          command   => "racadm config -g cfgLanNetworking -o cfgDNSServer2 ${drac_dns2}",
          path      => "$dell_path",
          timeout   => 1800,
          onlyif    => "test `racadm getconfig -g cfgLanNetworking -o cfgDNSServer2` != ${drac_dns2}",
        }
      }

      if $drac_dns_domain {
        exec { 'Set DRAC DNS Domain':
          command   => "racadm config -g cfgLanNetworking -o cfgDNSDomainName ${drac_dns_domain}",
          path      => "$dell_path",
          timeout   => 1800,
          onlyif    => "test `racadm getconfig -g cfgLanNetworking -o cfgDNSDomainName` -z",
        }
      }

      if $drac_rac_name {
        exec { 'Set DRAC RAC Name':
          command   => "racadm config -g cfgLanNetworking -o cfgDNSRacName ${drac_rac_name}",
          path      => "$dell_path",
          timeout   => 1800,
          onlyif    => "test `racadm getconfig -g cfgLanNetworking -o cfgDNSRacName` != ${drac_rac_name}",
        }
      }
      
      if $drac_enable_ipmisol {
        exec { 'Enable/Disable IPMI - Serial Over LAN':
          command => "racadm config -g cfgIpmiSol -o cfgIpmiSolEnable ${drac_enable_ipmisol}",
          path    => "$dell_path",
          timeout => 1800,
          onlyif  => "test `racadm getconfig -g cfgIpmiSol -o cfgIpmiSolEnable` != ${drac_enable_ipmisol}",
        }
      }
    }
  }
  else {
    notice("No DRAC detected, not attempting to configure DRAC settings. Check facter -p | grep hasdrac")
  }
}
