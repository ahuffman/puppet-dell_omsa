class dell_omsa::config_drac_email inherits ::dell_omsa {
  if $::hasdrac == 1 {
    #Manage DRAC Email alerting
    if $manage_drac_email == true {
      notice("Managing DRAC Email Alerting for $::clientcert.")
      exec { 'Enable DRAC Global Alerting':
        command     => 'racadm config -g cfgIpmiLan -o cfgIpmiLanAlertEnable 1',
        path        => "$dell_path",
        timeout     => 1800,
        onlyif      => "test `racadm getconfig -g cfgIpmiLan -o cfgIpmiLanAlertEnable` -ne 1",
      }
      exec { 'Set DRAC SMTP Relay':
        command     => "racadm config -g cfgRemoteHosts -o cfgRhostsSmtpServerIpAddr ${drac_smtp_relay}",
        path        => "$dell_path",
        timeout     => 1800,
        onlyif      => "test `racadm getconfig -g cfgRemoteHosts -o cfgRhostsSmtpServerIpAddr` != ${drac_smtp_relay}",
      }
      exec { 'Ensure DRAC Email Destination':
        command     => "racadm config -g cfgEmailAlert -o cfgEmailAlertAddress -i 1 ${drac_alert_email}",
        path        => "$dell_path",
        timeout     => 1800,
        onlyif      => "test `racadm getconfig -g cfgEmailAlert -o cfgEmailAlertAddress -i 1` -z",
      }
      exec { 'Enable DRAC Email alert for destination':
        command     => 'racadm config -g cfgEmailAlert -o cfgEmailAlertEnable -i 1 1',
        path        => "$dell_path",
        timeout     => 1800,
        onlyif      => "test `racadm getconfig -g cfgEmailAlert -o cfgEmailAlertEnable -i 1` -ne 1",
      }
      exec { 'Ensure DRAC Email Custom Message':
        command     => "racadm config -g cfgEmailAlert -o cfgEmailAlertCustomMsg -i 1 ${drac_rac_name}",
        path        => "$dell_path",
        timeout     => 1800,
        onlyif      => "test `racadm getconfig -g cfgEmailAlert -o cfgEmailAlertCustomMsg -i 1` -z"
      }
      #proper ordering
      Exec['Enable DRAC Global Alerting'] -> Exec['Set DRAC SMTP Relay'] -> Exec['Ensure DRAC Email Destination'] -> Exec['Enable DRAC Email alert for destination'] -> Exec['Ensure DRAC Email Custom Message']
    }
  }
  else {
    notice("No DRAC detected, not attempting to configure DRAC settings. Check facter -p | grep hasdrac")
  }
}
