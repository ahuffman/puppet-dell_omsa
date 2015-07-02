class dell_omsa::firewall inherits dell_omsa {
  notice("Managing Iptables rules regarding Dell Software for $::clientcert")
  #Check if we have the firewall enabled before applying rules
  if $manage_firewall == true {
    #Open OMSA firewall ports
    firewall {'200 Accept Dell OMSA https Web connections':
      port   => '1311',
      proto  => 'tcp',
      action => 'accept',
    }

    firewall {'200 Accept Dell OMSA SNMP Requests':
      port   => [ '161', '162' ],
      proto  => 'udp',
      action => 'accept',
    }

    firewall {'200 Accept Dell OMSA Remote Flash BIOS connections UDP':
      port   => '11487',
      proto  => 'udp',
      action => 'accept',
    }

    firewall {'200 Accept Dell OMSA Remote Flash BIOS connections TCP':
      port   => '11489',
      proto  => 'tcp',
      action => 'accept',
    }
  }
}

