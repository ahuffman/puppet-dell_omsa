class dell_omsa::config_omsa_cert inherits ::dell_omsa {
  if $manage_omsa_certificate == true {
    notice("Managing OMSA Certificate Configuration for $::clientcert")

    #make sure we have openssl installed
    ensure_packages('openssl098e', {'ensure' => 'latest' })
    #Set Encryption Level
    if ($omsa_ks_encrypt_level) and ($omsa_ks_pw) and ($omsa_ks_filename) and ($omsa_ks_cn) and ($omsa_ks_issuer_cn) {
      #Grab the omsa cert
      file { "/tmp/${omsa_ks_filename}":
        source => "puppet:///modules/dell_omsa/certs/${omsa_ks_filename}",
        ensure => 'present',
        group  => 'root',
        owner  => 'root',
        mode   => '444',
        notify => Exec['Set OMSA Certificate Encryption'],
      }
      exec { 'Set OMSA Certificate Encryption':
        command     => "omconfig preferences webserver attribute=sslencryption setting=${omsa_ks_encrypt_level}",
        path        => "$dell_path",
        timeout     => 1800,
        refreshonly => true,
      }
      #Upload Certificate
      exec { 'Upload OMSA Certificate':
        command     => "omconfig preferences webserver attribute=uploadcert certfile=/tmp/${omsa_ks_filename} type=pkcs12 password=${omsa_ks_pw} webserverrestart=true",
        path        => "$dell_path",
        timeout     => 1800,
        onlyif      => [
                         "test `openssl s_client -connect $::clientcert:1311 2>/dev/null | sed -n 's/^\s\+Verify\sreturn\scode:\s\+\([0-9]\+\).*/\1/p'` -gt 0 || exit 0",
                         "openssl s_client -connect $::clientcert:1311 2>/dev/null | grep \"subject=.*${omsa_ks_cn}\"; test $? -gt 0",
                         "openssl s_client -connect $::clientcert:1311 2>/dev/null | grep \"issuer=.*${omsa_ks_issuer_cn}\"; test $? -gt 0"
                       ],
        require     => File["/tmp/${omsa_ks_filename}"],
      }

    }
  }
}
