# == Class: supervisor
#
# Puppet supervisor module.
#
class supervisor (
  $package                      = true,
  $service                      = true,
  $enable                       = true,
  # Defaults for [unix_http_server] section.
  $unix_http_server             = true,
  $unix_http_server_file        = '/var/run//supervisor.sock',
  $unix_http_server_chmod       = '0700',
  $unix_http_server_chown       = undef,
  $unix_http_server_username    = undef,
  $unix_http_server_password    = undef,
  # Defaults for [inet_http_server] section.
  $inet_http_server             = false,
  $inet_http_server_port        = undef,
  $inet_http_server_username    = undef,
  $inet_http_server_password    = undef,
  # Defaults for[supervisord] section.
  $supervisord                  = true,
  $supervisord_logfile          = '/var/log/supervisor/supervisord.log',
  $supervisord_logfile_maxbytes = undef,
  $supervisord_logfile_backups  = undef,
  $supervisord_loglevel         = undef,
  $supervisord_pidfile          = '/var/run/supervisord.pid',
  $supervisord_umask            = '022',
  $supervisord_nodaemon         = false,
  $supervisord_minfds           = undef,
  $supervisord_minprocs         = undef,
  $supervisord_nocleanup        = undef,
  $supervisord_childlogdir      = '/var/log/supervisor',
  $supervisord_user             = undef,
  $supervisord_directory        = undef,
  $supervisord_strip_ansi       = undef,
  $supervisord_environment      = undef,
  $supervisord_identifier       = 'supervisor',
  # Defaults for [supervisorctl] section.
  $supervisorctl                = true,
  $supervisorctl_serverurl      = 'unix:///var/run//supervisor.sock',
  $supervisorctl_username       = undef,
  $supervisorctl_password       = undef,
  $supervisorctl_promt          = undef,
  $supervisorctl_history_file   = undef,
  # Daemon options.
  $supervisor_sysconfog_options = undef) {
  # Include supervisor::params
  include supervisor::params

  $supervisor_package_name = $supervisor::params::supervisor_package_name
  $supervisor_service_name = $supervisor::params::supervisor_service_name
  $supervisor_conf_dir     = $supervisor::params::supervisor_conf_dir
  $supervisor_conf_file    = $supervisor::params::supervisor_conf_file
  $supervisor_sysconfig    = $supervisor::params::supervisor_sysconfig

  if $supervisor_sysconfig_options == undef {
    $supervisor_sysconfig_options =
    $supervisor::params::supervisor_sysconfig_options
  }

  case $package {
    true    : { $ensure_package = 'present' }
    false   : { $ensure_package = 'purged' }
    latest  : { $ensure_package = 'latest' }
    default : { fail('package must be true, false or lastest') }
  }

  case $service {
    true    : { $ensure_service = 'running' }
    false   : { $ensure_service = 'stopped' }
    default : { fail('service must be true or false') }
  }

  package { $supervisor_package_name: ensure => $ensure_package, }

  if ($package == true) or ($package == latest) {
    service { $supervisor_service_name:
      ensure     => $ensure_service,
      enable     => $enable,
      hasrestart => true,
      hasstatus  => true,
      restart    => 'supervisorctl reload',
      require    => Package[$supervisor_package_name],
    }

    # /etc/supervisor.conf
    file { $supervisor_conf_file:
      ensure  => present,
      path    => $supervisor_conf_file,
      mode    => '0644',
      content => template('supervisor/supervisor.conf.erb')
    }

    # /etc/default/supervisor
    file { $supervisor_sysconfig:
      ensure  => present,
      path    => $supervisor_sysconfig,
      mode    => '0644',
      content => template("supervisor/sysconfig.${::operatingsystem}.erb"),
      require => Package[$supervisor_package_name],
      notify  => Service[$supervisor_service_name],
    }

    # /etc/supervisor/conf.d
    file { $supervisor_conf_dir:
      ensure  => directory,
      mode    => '0755',
      require => Package[$supervisor_package_name],
      notify  => Service[$supervisor_service_name],
    }

    # 01-unix_http_server.conf
    if $unix_http_server == true {
      file { "${supervisor_conf_dir}/01-unix_http_server.conf":
        ensure  => present,
        backup  => true,
        path    => "${supervisor_conf_dir}/01-unix_http_server.conf",
        mode    => '0644',
        content => template('supervisor/unix_http_server.conf.erb'),
        require => [
          Package[$supervisor_package_name],
          File[$supervisor_conf_dir]],
        notify  => Service[$supervisor_service_name],
      }
    }

    # 02-inet_http_server.conf
    if $inet_http_server == true {
      file { "${supervisor_conf_dir}/02-inet_http_server.conf":
        ensure  => present,
        backup  => true,
        path    => "${supervisor_conf_dir}/02-inet_http_server.conf",
        mode    => '0644',
        content => template('supervisor/inet_http_server.conf.erb'),
        require => [
          Package[$supervisor_package_name],
          File[$supervisor_conf_dir]],
        notify  => Service[$supervisor_service_name],
      }
    }

    # 03-supervisord.conf
    if $supervisord == true {
      file { "${supervisor_conf_dir}/03-supervisord.conf":
        ensure  => present,
        backup  => true,
        path    => "${supervisor_conf_dir}/03-supervisord.conf",
        mode    => '0644',
        content => template('supervisor/supervisord.conf.erb'),
        require => [
          Package[$supervisor_package_name],
          File[$supervisor_conf_dir]],
        notify  => Service[$supervisor_service_name],
      }
    }

    # 04-supervisorctl.conf
    if $supervisorctl == true {
      file { "${supervisor_conf_dir}/04-supervisorctl.conf":
        ensure  => present,
        backup  => true,
        path    => "${supervisor_conf_dir}/04-supervisorctl.conf",
        mode    => '0644',
        content => template('supervisor/supervisorctl.conf.erb'),
        require => [
          Package[$supervisor_package_name],
          File[$supervisor_conf_dir]],
        notify  => Service[$supervisor_service_name],
      }
    }
  }
}
# EOF
