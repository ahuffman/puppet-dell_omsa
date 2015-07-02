class dell_omsa::dell_repos inherits ::dell_omsa {
  #Setup Dell OMSA Repositories - gpg keys 2-lines important here
  if $manage_repos == true {
    notice("Managing Dell Software Repositories for $::clientcert")
    yumrepo {
      'dell-omsa-indep':
        descr            => 'Dell OMSA repository - Hardware independent',
        enabled          => 1,
        ensure           => 'present',
        failovermethod   => 'priority',
        gpgcheck         => 1,
        gpgkey           => "${dell_repo_gpgkeys}",
        mirrorlist       => 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver';

      'dell-omsa-specific':
        descr            => 'Dell OMSA repository - Hardware specific',
        enabled          => 1,
        ensure           => 'present',
        failovermethod   => 'priority',
        gpgcheck         => 1,
        gpgkey           => "${dell_repo_gpgkeys}",
        mirrorlist       => 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver';
    }

    #Install Dell Yum Plugin
    package { 'yum-dellsysid':
      ensure  => 'latest',
      require => [ Yumrepo['dell-omsa-indep'], Yumrepo['dell-omsa-specific'] ],
    }
  }
}
