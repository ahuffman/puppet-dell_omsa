class dell_omsa::config_drac_cert inherits ::dell_omsa {
  if $::hasdrac == 1 {
    #DRAC Certificates
    if $manage_drac_certificate == true {
      notice("Managing DRAC Certificate Configuration for $::clientcert")
      #Download the certificate,  check the certificate vs drac existing certificate, if no match grab and install the private key,
      #install the cert and restart the drac to refresh the config, remove the private key file for obvious security reasons

      file { "/tmp/${drac_cert_filename}":
        source  => "puppet:///modules/dell_omsa/certs/${drac_cert_filename}",
        ensure  => 'present',
        group   => 'root',
        owner   => 'root',
        mode    => '444',
      }

      exec { 'Create DRAC Temporary Private Keyfile':
        refreshonly => true,
        command     => "echo \"${drac_cert_private_cont}\" > /tmp/private.key",
        path        => "$dell_path",
        timeout     => 1800,
      }

      exec { 'Install DRAC Private Key':
        refreshonly  => true,
        command      => 'racadm sslkeyupload -t 1 -f /tmp/private.key',
        path         => "$dell_path",
        timeout      => 1800,
        require      => Exec['Create DRAC Temporary Private Keyfile'],
        notify       => Exec['Remove DRAC Temporary Private Keyfile'],
      }

      exec { 'Download Existing DRAC Certificate':
        command  => 'racadm sslcertdownload -t 1 -f /tmp/download.crt',
        path     => "$dell_path",
        timeout  => 6400,
        onlyif   => "diff /tmp/download.crt /tmp/${drac_cert_filename}; test $? -ne 0",
        require  => File["/tmp/${drac_cert_filename}"],
      }

      exec { 'Check Current DRAC Certificate':
        command  => "ls /tmp/", #hacky way to trick into thinking we have a successful exec the onlyif is the key to this
        path     => "$dell_path",
        timeout  => 1800,
        onlyif   => "diff /tmp/download.crt /tmp/${drac_cert_filename}; test $? -ne 0", #If fails we notify the privatekey to install
        notify   => [
                      Exec['Create DRAC Temporary Private Keyfile'],
                      Exec['Install DRAC Private Key'],
                    ],
        require  => Exec['Download Existing DRAC Certificate'],
      }
	  
      exec { 'Install DRAC Certificate':
        command  => "racadm sslcertupload -t 1 -f /tmp/${drac_cert_filename};  racadm racreset", #even though an error occurs on the upload, it actually still works
        path     => "$dell_path",
        timeout  => 6400,
        require  => [
                      File["/tmp/${drac_cert_filename}"],
                      Exec['Install DRAC Private Key'],
                    ],
        onlyif   => "diff /tmp/download.crt /tmp/${drac_cert_filename}; test $? -ne 0",
      }

      exec { 'Remove DRAC Temporary Private Keyfile':
        refreshonly => true,
        command     => 'rm -f /tmp/private.key',
        path        => "$dell_path",
        timeout     => 1800,
      }
    }
  }
  else {
    notice("No DRAC detected, not attempting to configure DRAC settings. Check facter -p | grep hasdrac")
  }
}
