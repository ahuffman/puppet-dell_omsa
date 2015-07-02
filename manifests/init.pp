# == Class: dell_omsa
#
# Manages Dell OMSA repositories, omsa install, services, drac configuration, and omsa/drac firewall configuration.
#
# === Parameters
#
#
# [*manage_install*]
#  default => true
#    Whether or not to install OMSA and utilities (srvadmin-all)
#
# [*manage_repos*]
#  default => true
#    Whether or not to configure Dell's repositories in yum.repos.d
#
# [*manage_services*]
#  default => true
#    Whether or not to manage OMSA's services
#
# [*manage_firewall*]
#  default => false
#    Whether or not to configure iptables firewall rules for OMSA services
#
# [*manage_drac_nic*]
#  default => false
#    Whether or not to manage the DRAC NIC configuration.  The following paramaters are required if so, unless otherwise noted
#
# [*manage_omsa_certificate*]
#  default => false
#    Whether or not to manage the OMSA certificate configuration.
#
# [*drac_ip*]
#  default => undef
#    The IP Address of your DRAC NIC
#
# [*drac_netmask*]
#  default => undef
#    The netmask for your DRAC NIC's configuration
#
# [*drac_gateway*]
#  default => undef
#    The gateway required for your DRAC NIC's configuration
#
# [*drac_dns1*]
#  default => undef
#    DNS Server1 for your DRAC NIC's configuration (optional)
#
# [*drac_dns2*]
#  default => undef
#    DNS Server2 for your DRAC NIC's configuration (optional)
#
# [*drac_dns_domain*]
#  default => undef
#    DNS Domain for your DRAC NIC's configuration (optional) ex. mydomain.com (optional)
#
# [*drac_rac_name*]
#  default => undef
#    Hostname of your DRAC (optional)
#
# [*manage_drac_email*]
#  default => false
#    Whether or not to manage DRAC's email alerts. The following parameters are required if so, unless otherwise noted
#
# [*drac_alert_email*]
#  default => undef
#    The email address you wish to send DRAC email alerts to.  A distribution group is recommended.
#
# [*drac_smtp_relay*]
#  default => undef
#    The IP address of your organization's SMTP relay server
#
# [*manage_drac_logins*]
#  default => false
#    Whether or not to manage the admin users on your DRAC.  This module is currently limited to 2 Admin users.  The following parameters are required if so, unless otherwise noted
#
# [*drac_admin_user1*]
#  default => undef
#    The username of admin user1 (usually root on a factory drac config)
#
# [*drac_admin_user2*]
#  default => undef
#    The username of admin user2 (usually null on a factory drac config)
#
# [*drac_admin_pw1*]
#  default => undef
#    The password for drac_admin_user1. Recommended to store this value in eyaml for encrypted password storage.
#
# [*drac_admin_pw2*]
#  default => undef
#    The password for drac_admin_user2. Recommended to store this value in eyaml for encrypted password storage.
#
# [*admin_user1_priv_enable*]
#  default => 1
#    Whether or not to enable drac_admin_user1
#
# [*admin_user1_priv_sol_enable*]
#  default => 1
#    Whether or not to enable Serial Over LAN connections for drac_admin_user1
#
# [*admin_user1_priv_ipmi_serial*]
#  default => 4
#    Access granted for IPMI Serial connections for drac_admin_user1 (See DRAC Manual)
#
# [*admin_user1_priv_ipmi_lan*]
#  default => 4
#    Access granted for IPMI LAN connections for drac_admin_user1 (See DRAC Manual)
#
# [*admin_user1_priv_rac*]
#  default => '0x00001ff' (full access)
#    Access granted to the DRAC web console for drac_admin_user1 (See DRAC Manual)
#
# [*admin_user2_priv_enable*]
#  default => 1
#    Whether or not to enable drac_admin_user2
#
# [*admin_user2_priv_sol_enable*]
#  default => 1
#    Whether or not to enable Serial Over LAN connections for drac_admin_user2
#
# [*admin_user2_priv_ipmi_serial*]
#  default => 4
#    Access granted for IPMI Serial connections for drac_admin_user2 (See DRAC Manual)
#
# [*admin_user2_priv_ipmi_lan*]
#  default => 4
#    Access granted for IPMI LAN connections for drac_admin_user2 (See DRAC Manual)
#
# [*admin_user2_priv_rac*]
#  default => '0x00001ff' (full access)
#    Access granted to the DRAC web console for drac_admin_user2 (See DRAC Manual)
#
# [*manage_drac_certificate*]
#  default => false
#    Whether or not to manage the DRAC web console SSL Certificate. The following parameters are required if so, unless otherwise noted.
#
# [*drac_cert_filename*]
#  default => undef
#    The filename containing your DRAC's SSL cert, placed in this module's files/certs/ directory. Do not include the path, just the filename.
#    The certificate file must have the DRAC SSL certificate contents, followed by a CRLF (carriage return line feed), and finally the contents of the CA's intermediate
#      chaining certificate (if any)
#
# [*drac_cert_private_cont*]
#  default => undef
#    The SSL Certificate's private key contents.  It is highly highly recommended to place the contents of your private SSL key into eyaml to keep it encrypted!
#    Required for installing the SSL Certificate. Used to create a temporary file in /tmp/private.key, and removed after installing the certificate.
#
# [*$drac_enable_ipmisol*]
#  default => 0
#    Whether or not to enable IPMI Serial over LAN - Warning, if enabled, this can lead to known vulnerabilities if misconfigured
#
# [*$omsa_svcs*]
#  default => ['racsvc','instsvcdrv','dataeng','dsm_om_shrsvc','dsm_om_connsvc']
#    Which omsa services to manage
#
# [*$omsa_pkg*]
#  default => srvadmin-all #latest version
#    Which omsa package to install.  If a version is specified then it will ensure that version is installed.
#
# [*$omsa_version*]
#  default => latest
#    Provides ability to specify a version of the omsa srvadmin package to install (if desired)
#
# [*$omsa_ks_pw*]
#  default => undef #This should be encryped in eyaml
#    Key Store password for pkcs12 omsa certificate keystore
#
# [*$omsa_ks_filename*]
#  default => undef
#    Filename of the pkcs12 keystore to be used for configuring the omsa certificate (relative to files/certs/)
#
# [*omsa_ks_encrypt_level*]
#  default => undef
#    This can be either autonegotiate or 128bitorhigher.  Used in configuration of omsa certificate
#
# [*omsa_ks_cn*]
#  default => undef
#    Required for verifying the validity of your OMSA certificate.  The CN of your OMSA certificate.
#
# [*omsa_ks_issuer_cn*]
#  default => undef
#    Required for verifying the validity of your OMSA certificate.  The CN of your OMSA certificate's issuer (certificate authority.)
#
# === Examples
#
#   class { 'dell_omsa':
#     manage_drac_nic          => true,
#     manage_drac_logins       => true,
#     manage_drac_email        => true,
#     manage_drac_certificate  => true,
#     manage_omsa_certificate  => true,
#     manage_firewall          => true,
#     drac_ip                  => '1.1.1.2',
#     drac_netmask             => '255.255.255.0',
#     drac_gateway             => '1.1.1.1',
#     drac_dns1                => '1.1.1.3',
#     drac_dns2                => '1.1.1.4',
#     drac_dns_domain          => 'mydomain.com',
#     drac_rac_name            => 'myhostname-drac',
#     drac_smtp_relay          => '1.1.1.5',
#     drac_alert_email         => 'alertemail@mydomain.com',
#     drac_admin_user1         => 'root',
#     drac_admin_user2         => 'adminuser',
#     drac_cert_filename       => 'mycert.crt',
#     omsa_ks_filename         => 'mycert.p12',
#     omsa_ks_encrypt_level    => '128bitorhigher',
#     omsa_ks_issuer_cn        => 'My CA cert issuer',
#     omsa_ks_cn               => '*.mydomain.com',    #example for a wildcard certificate
#   }
#  Note that the above configuration left out 4 things, drac_admin_pw1, drac_admin_pw2, drac_cert_private_cont, and omsa_ks_pw, all of which should be stored in eyaml.
#
#
#  Hiera/YAML Example
#  mynode.yaml:
#  ---
#  #DRAC Configuration
#  dell_omsa::manage_drac_certificate: true
#  dell_omsa::manage_omsa_certificate: true
#  dell_omsa::manage_drac_logins: true
#  dell_omsa::manage_drac_nic: true
#  dell_omsa::manage_drac_email: true
#  dell_omsa::manage_firewall: true
#  #DRAC Networking
#  dell_omsa::drac_ip: '1.1.1.2'
#  dell_omsa::drac_netmask: '255.255.255.0'
#  dell_omsa::drac_gateway: '1.1.1.1'
#  dell_omsa::drac_dns1: '1.1.1.3'
#  dell_omsa::drac_dns2: '1.1.1.4'
#  dell_omsa::drac_dns_domain: 'mydomain.com'
#  dell_omsa::drac_rac_name: 'myhostname-drac'
#  #DRAC Email Alerts
#  dell_omsa::drac_alert_email: 'alertemail@mydomain.com'
#  dell_omsa::drac_smtp_relay: '1.1.1.5'
#  #DRAC Users
#  dell_omsa::drac_admin_user1: 'root'
#  dell_omsa::drac_admin_user2: 'adminuser'
#  #DRAC Certificate
#  dell_omsa::drac_cert_filename: 'mycert.crt'
#  #OMSA Certificate
#  dell_omsa::omsa_ks_filename: 'mycert.p12'
#  dell_omsa::omsa_ks_encrypt_level: '128bitorhigher'
#  dell_omsa::omsa_ks_issuer_cn: 'My CA cert issuer'
#  dell_omsa::omsa_ks_cn: '*.mydomain.com'
#
#  secure.eyaml:
#  ---
#  drac_admin_pw1: ......
#  drac_admin_pw2: ......
#  drac_cert_private_cont: .....
#  dell_omsa::omsa_ks_pw: .....
#
#
#
#
# === Authors
#
# Andrew Huffman <andrew.j.huffman@gmail.com>
#
# === Copyright
#
# Copyright 2015 Andrew Huffman <andrew.j.huffman@gmail.com>, unless otherwise noted.
#


class dell_omsa (
  #define parameters
    $manage_drac_certificate           = $::dell_omsa::params::manage_certificate,
    $manage_firewall                   = $::dell_omsa::params::manage_firewall,
    $manage_install                    = $::dell_omsa::params::manage_install,
    $manage_drac_logins                = $::dell_omsa::params::manage_drac_passwords,
    $manage_repos                      = $::dell_omsa::params::manage_repos,
    $manage_services                   = $::dell_omsa::params::manage_services,
    $manage_drac_nic                   = $::dell_omsa::params::manage_drac_nic,
    $manage_drac_email                 = $::dell_omsa::params::manage_drac_email,
    $manage_omsa_certificate           = $::dell_omsa::params::manage_omsa_certificate,
    $drac_cert_filename                = $::dell_omsa::params::drac_cert_filename,
    $drac_cert_private_cont            = $::dell_omsa::params::drac_cert_private_cont,
    $drac_smtp_relay                   = $::dell_omsa::params::drac_smtp_relay,
    $drac_alert_email                  = $::dell_omsa::params::drac_alert_email,
    $drac_ip                           = $::dell_omsa::params::drac_ip,
    $drac_gateway                      = $::dell_omsa::params::drac_gateway,
    $drac_netmask                      = $::dell_omsa::params::drac_netmask,
    $drac_dns1                         = $::dell_omsa::params::drac_dns1,
    $drac_dns2                         = $::dell_omsa::params::drac_dns2,
    $drac_dns_domain                   = $::dell_omsa::params::drac_dns_domain,
    $drac_rac_name                     = $::dell_omsa::params::drac_rac_name,
    $dell_path                         = $::dell_omsa::params::dell_path,
    $drac_admin_user1                  = $::dell_omsa::params::drac_admin_user1,
    $drac_admin_user1_priv_enable      = $::dell_omsa::params::drac_admin_user1_priv_enable,
    $drac_admin_user1_priv_sol_enable  = $::dell_omsa::params::drac_admin_user1_priv_sol_enable,
    $drac_admin_user1_priv_ipmi_serial = $::dell_omsa::params::drac_admin_user1_priv_ipmi_serial,
    $drac_admin_user1_priv_ipmi_lan    = $::dell_omsa::params::drac_admin_user1_priv_ipmi_lan,
    $drac_admin_user1_priv_rac         = $::dell_omsa::params::drac_admin_user1_priv_rac,
    $drac_admin_user2                  = $::dell_omsa::params::drac_admin_user2,
    $drac_admin_user2_priv_enable      = $::dell_omsa::params::drac_admin_user2_priv_enable,
    $drac_admin_user2_priv_sol_enable  = $::dell_omsa::params::drac_admin_user2_priv_sol_enable,
    $drac_admin_user2_priv_ipmi_serial = $::dell_omsa::params::drac_admin_user2_priv_ipmi_serial,
    $drac_admin_user2_priv_ipmi_lan    = $::dell_omsa::params::drac_admin_user2_priv_ipmi_lan,
    $drac_admin_user2_priv_rac         = $::dell_omsa::params::drac_admin_user2_priv_rac,
    $drac_admin_pw1                    = $::dell_omsa::params::drac_admin_pw1,
    $drac_admin_pw2                    = $::dell_omsa::params::drac_admin_pw2,
    $omsa_ks_pw                        = $::dell_omsa::params::omsa_ks_pw,
    $omsa_ks_filename                  = $::dell_omsa::params::omsa_ks_filename,
    $omsa_ks_encrypt_level             = $::dell_omsa::params::omsa_ks_encrypt_level,
    $omsa_ks_cn                        = $::dell_omsa::params::omsa_ks_cn,
    $omsa_ks_issuer_cn                 = $::dell_omsa::params::omsa_ks_issuer_cn,
    $omsa_pkg                          = $::dell_omsa::params::omsa_pkg,
    $omsa_svcs                         = $::dell_omsa::params::omsa_svcs,
    $omsa_ensure                       = $::dell_omsa::params::omsa_ensure,
    $dell_repo_gpgkeys                 = $::dell_omsa::params::dell_repo_gpgkeys,
    $drac_enable_ipmisol               = $::dell_omsa::params::drac_enable_ipmisol
    
) inherits dell_omsa::params {

  include ::stdlib
  include ::dell_omsa::dell_repos
  include ::dell_omsa::install
  include ::dell_omsa::service
  include ::dell_omsa::config_drac_nic
  include ::dell_omsa::config_drac_email
  include ::dell_omsa::config_drac_users
  include ::dell_omsa::config_drac_cert
  include ::dell_omsa::config_omsa_cert
  include ::dell_omsa::firewall

  #Proper ordering
  Class['dell_omsa::dell_repos'] -> Class['dell_omsa::install'] ~> Class['dell_omsa::service'] -> Class['dell_omsa::config_drac_nic'] -> Class['dell_omsa::config_drac_email'] -> Class['dell_omsa::config_drac_users'] -> Class['dell_omsa::config_drac_cert'] -> Class['dell_omsa::config_omsa_cert'] -> Class['dell_omsa::firewall']

}
