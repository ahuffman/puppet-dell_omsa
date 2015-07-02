class dell_omsa::config_drac_users inherits ::dell_omsa {
  if $manage_drac_logins == true {
    $subscribes = [ Class['::dell_omsa::install'], Class['::dell_omsa::service'] ]
    #Manage DRAC logins
    if $::hasdrac == 1 {
      #Include puppetlabs-stdlib module for ensure_packages function
      notice("Managing DRAC User logins for $::clientcert.")
      if $drac_admin_user1 {
        ensure_packages('openssl098e', {'ensure' => 'latest' })
        exec { 'Ensure DRAC Admin1 User':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminUserName -i 2 \"\" && racadm config -g cfgUserAdmin -o cfgUserAdminUserName -i 2 ${drac_admin_user1}",
          onlyif      => "test ! `racadm getconfig -g cfgUserAdmin -i 2 | grep ^cfgUserAdminUserName | sed -n -e 's/^cfgUserAdminUserName=//p' | wc -m` -gt 1",
          path        => "$dell_path",
          timeout     => 1800,
        }
#Testing RAC Passwords must have openssl098e installed and drac_ip set at node level: racadm -r drac_ip -u drac_admin_userX -p drac_admin_pw2 getniccfg quick test look for ret
        exec { 'Set DRAC Admin1 Password':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminPassword -i 2 ${drac_admin_pw1}",
          path        => "$dell_path",
          timeout     => 1800,
          onlyif      => "racadm -r ${drac_ip} -u ${drac_admin_user1} -p ${drac_admin_pw1} getniccfg; test $? -ne 0",
        }

        exec { 'Set DRAC Admin1 Privileges - RAC':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminPrivilege -i 2 ${drac_admin_user1_priv_rac}",
          path        => "$dell_path",
          timeout     => 1800,
          onlyif      => "test `racadm getconfig -g cfgUserAdmin -o cfgUserAdminPrivilege -i 2` != ${drac_admin_user1_priv_rac}",
        }

        exec { 'Set DRAC Admin1 Privileges - IPMI LAN':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminIpmiLanPrivilege -i 2 ${drac_admin_user1_priv_ipmi_lan}",
          path        => "$dell_path",
          timeout     => 1800,
          onlyif      => "test `racadm getconfig -g cfgUserAdmin -o cfgUserAdminIpmiLanPrivilege -i 2` != ${drac_admin_user1_priv_ipmi_lan}",
        }

        exec { 'Set DRAC Admin1 Privileges - IPMI Serial':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminIpmiSerialPrivilege -i 2 ${drac_admin_user1_priv_ipmi_serial}",
          path        => "$dell_path",
          timeout     => 1800,
          onlyif      => "test `racadm getconfig -g cfgUserAdmin -o cfgUserAdminIpmiSerialPrivilege -i 2` != ${drac_admin_user1_priv_ipmi_serial}",
        }

        exec { 'Set DRAC Admin1 Privileges - Serial Over LAN':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminSolEnable -i 2 ${drac_admin_user1_priv_sol_enable}",
          path        => "$dell_path",
          timeout     => 1800,
          onlyif      => "test `racadm getconfig -g cfgUserAdmin -o cfgUserAdminSolEnable -i 2` != ${drac_admin_user1_priv_sol_enable}",
        }
          exec { 'Enable/Disable DRAC Admin1 User':
            command     => "racadm config -g cfgUserAdmin -o cfgUserAdminEnable -i 2 ${drac_admin_user1_priv_enable}",
            path        => "$dell_path",
            timeout     => 1800,
            onlyif      => "test `racadm getconfig -g cfgUserAdmin -o cfgUserAdminEnable -i 2` != ${drac_admin_user1_priv_enable}",
          }

        Exec['Ensure DRAC Admin1 User'] -> Exec['Set DRAC Admin1 Password'] -> Exec['Set DRAC Admin1 Privileges - RAC'] -> Exec['Set DRAC Admin1 Privileges - IPMI LAN'] -> Exec['Set DRAC Admin1 Privileges - IPMI Serial'] -> Exec['Set DRAC Admin1 Privileges - Serial Over LAN'] -> Exec['Enable/Disable DRAC Admin1 User']
      }

      if $drac_admin_user2 {
        ensure_packages('openssl098e', {'ensure' => 'latest' })
        exec { 'Ensure DRAC Admin2 User':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminUserName -i 3 \"\" && racadm config -g cfgUserAdmin -o cfgUserAdminUserName -i 3 ${drac_admin_user2}",
          onlyif      => "test ! `racadm getconfig -g cfgUserAdmin -i 3 | grep ^cfgUserAdminUserName | sed -n -e 's/^cfgUserAdminUserName=//p' | wc -m` -gt 1",
          path        => "$dell_path",
          timeout     => 1800,
        }

        exec { 'Set DRAC Admin2 Password':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminPassword -i 3 ${drac_admin_pw2}",
          path        => "$dell_path",
          timeout     => 1800,
          onlyif      => "racadm -r ${drac_ip} -u ${drac_admin_user2} -p ${drac_admin_pw2} getniccfg; test $? -ne 0",
        }

        exec { 'Set DRAC Admin2 Privileges - RAC':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminPrivilege -i 3 ${drac_admin_user2_priv_rac}",
          path        => "$dell_path",
          timeout     => 1800,
          onlyif      => "test `racadm getconfig -g cfgUserAdmin -o cfgUserAdminPrivilege -i 3` != ${drac_admin_user2_priv_rac}",
        }

        exec { 'Set DRAC Admin2 Privileges - IPMI LAN':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminIpmiLanPrivilege -i 3 ${drac_admin_user2_priv_ipmi_lan}",
          path        => "$dell_path",
          timeout     => 1800,
          onlyif      => "test `racadm getconfig -g cfgUserAdmin -o cfgUserAdminIpmiLanPrivilege -i 3` != ${drac_admin_user2_priv_ipmi_lan}",
        }

        exec { 'Set DRAC Admin2 Privileges - IPMI Serial':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminIpmiSerialPrivilege -i 3 ${drac_admin_user2_priv_ipmi_serial}",
          path        => "$dell_path",
          timeout     => 1800,
          onlyif      => "test `racadm getconfig -g cfgUserAdmin -o cfgUserAdminIpmiSerialPrivilege -i 3` != ${drac_admin_user2_priv_ipmi_serial}",
        }

        exec { 'Set DRAC Admin2 Privileges - Serial Over LAN':
          command     => "racadm config -g cfgUserAdmin -o cfgUserAdminSolEnable -i 3 ${drac_admin_user2_priv_sol_enable}",
          path        => "$dell_path",
          timeout     => 1800,
          onlyif      => "test `racadm getconfig -g cfgUserAdmin -o cfgUserAdminSolEnable -i 3` != ${drac_admin_user2_priv_sol_enable}",
        }
          exec { 'Enable/Disable DRAC Admin2 User':
            command     => "racadm config -g cfgUserAdmin -o cfgUserAdminEnable -i 3 ${drac_admin_user2_priv_enable}",
            path        => "$dell_path",
            timeout     => 1800,
            onlyif      => "test `racadm getconfig -g cfgUserAdmin -o cfgUserAdminEnable -i 3` != ${drac_admin_user2_priv_enable}",
          }

        Exec['Ensure DRAC Admin2 User'] -> Exec['Set DRAC Admin2 Password'] -> Exec['Set DRAC Admin2 Privileges - RAC'] -> Exec['Set DRAC Admin2 Privileges - IPMI LAN'] -> Exec['Set DRAC Admin2 Privileges - IPMI Serial'] -> Exec['Set DRAC Admin2 Privileges - Serial Over LAN'] -> Exec['Enable/Disable DRAC Admin2 User']

      }
    }
  }
  else {
    notice("No DRAC detected, not attempting to configure DRAC settings. Check facter -p | grep hasdrac")
  }
}
