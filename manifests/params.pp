# == Class: supervisor::params
#
# This is a container class holding default parameters for supervisor class.
#
class supervisor::params {
  case $::operatingsystem {
    /(Debian|Ubuntu)/        : {
      $supervisor_package_name      = 'supervisor'
      $supervisor_service_name      = 'supervisor'
      $supervisor_conf_dir          = '/etc/supervisor/conf.d'
      $supervisor_conf_file         = 'supervisord.conf'
      $supervisor_sysconfig         = '/etc/default/supervisor'
      $supervisor_sysconfig_options = ''
      $supervisor_logrotate         = '/etc/logrotate.d/supervisor'
    }
    /(CentOS|Fedora|RedHat)/ : {
      $supervisor_package_name      = 'supervisor'
      $supervisor_service_name      = 'supervisor'
      $supervisor_conf_dir          = '/etc/supervisor/conf.d'
      $supervisor_conf_file         = 'supervisord.conf'
      $supervisor_sysconfig         = '/etc/sysconfig/supervisor'
      $supervisor_sysconfig_options = ''
      $supervisor_logrotate         = '/etc/logrotate.d/supervisor'
    }
    default                  : {
      fail("Module supervisor is not supported on ${::operatingsystem}")
    }
  }
}
# EOF
