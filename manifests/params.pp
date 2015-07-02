class dell_omsa::params {
    $manage_drac_certificate           = false
    $manage_firewall                   = false
    $manage_install                    = true
    $manage_drac_logins                = false
    $manage_repos                      = true
    $manage_services                   = true
    $manage_drac_nic                   = false
    $manage_drac_email                 = false
    $manage_omsa_certificate           = false
    $drac_enable_ipmisol               = 0     #Security vulnerability prevention
    $drac_cert_filename                = undef
    $drac_cert_private_cont            = undef
    $drac_smtp_relay                   = undef
    $drac_alert_email                  = undef
    $drac_ip                           = undef
    $drac_gateway                      = undef
    $drac_netmask                      = undef
    $drac_dns1                         = undef
    $drac_dns2                         = undef
    $drac_dns_domain                   = undef
    $drac_rac_name                     = undef
    $dell_path                         = '/opt/dell/srvadmin/sbin:/usr/bin:/bin'
    $drac_admin_user1                  = undef
    $drac_admin_user1_priv_enable      = 1
    $drac_admin_user1_priv_sol_enable  = 1
    $drac_admin_user1_priv_ipmi_serial = 4
    $drac_admin_user1_priv_ipmi_lan    = 4
    $drac_admin_user1_priv_rac         = '0x000001ff'
    $drac_admin_user2                  = undef
    $drac_admin_user2_priv_enable      = 1
    $drac_admin_user2_priv_sol_enable  = 1
    $drac_admin_user2_priv_ipmi_serial = 4
    $drac_admin_user2_priv_ipmi_lan    = 4
    $drac_admin_user2_priv_rac         = '0x000001ff'
    $drac_admin_pw1                    = undef
    $drac_admin_pw2                    = undef
    $omsa_version                      = undef
    $omsa_ks_pw                        = undef
    $omsa_ks_filename                  = undef
    $omsa_ks_encrypt_level             = undef #<autonegotiate|128bitorhigher>
    $omsa_ks_cn                        = undef
    $omsa_ks_issuer_cn                 = undef
    $omsa_svcs                         = ['racsvc','instsvcdrv','dataeng','dsm_om_shrsvc','dsm_om_connsvc']
    $dell_repo_gpgkeys                 = 'http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-dell
       http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-libsmbios'

    #Set the omsa package
    if $omsa_version == undef {
      $omsa_pkg = 'srvadmin-all'
      $omsa_ensure = 'latest'
    }
    else {
      $omsa_pkg    = "srvadmin-all.${omsa_version}"
      $omsa_ensure = 'installed'
    }
}
