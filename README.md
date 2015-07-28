# rentabiliweb-supervisor

[![Build Status](https://travis-ci.org/rentabiliweb/puppet-supervisor.svg?branch=master)](https://travis-ci.org/rentabiliweb/puppet-supervisor) [![Build Status](https://circleci.com/gh/:owner/:repo.svg?style=shield&circle-token=f4c4ad07d49a9b67ca7f6c866b01acfd5ae03f01)](https://circleci.com/gh/rentabiliweb/puppet-supervisor)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Development](#development)

## Overview

The rentabiliweb-supervisor module enables you to install, deploy, and configure
supervisor.

## Module Description

Supervisor  is a  client/server  system that  allows its  users  to monitor  and
control a number of processes on UNIX-like operating systems.

It shares  some of  the same  goals of programs  like launchd,  daemontools, and
runit. Unlike some of these programs, it is  not meant to be run as a substitute
for init as “process id 1”. Instead it  is meant to be used to control processes
related to a project or a customer, and is meant to start like any other program
at boot time.

http://supervisord.org/

## Setup

You   can   use   all  the   variables   you   can   find   in  the   manual   :
http://supervisord.org/configuration.html.   We  use   all  default   values  in
templates.

```puppet
class { 'supervisor':
  package                   => true,
  service                   => true,
  # daemon configuration
  supervisord_logfile       => '/var/log/supervisor/supervisord.log',
  supervisord_user          => 'root',
  # http server configuration
  inet_http_server          => '127.0.0.1',
  inet_http_server_port     => '8080',
  inet_http_server_username => 'login',
  inet_http_server_password => 'p4ssw0rd',
}
```

## Usage

```puppet
supervisor::program { 'rentabiliweb':
  program_command      => '/usr/sbin/rentabiliweb'
  program_process_name => 'rentabiliweb',
  program_autostart    => true,
  program_autorestart  => true,
  program_user         => 'www-data',
  program_environment  => 'DEBUG=true',
}
```

## Development

Rentabiliweb  modules on  the  Puppet  Forge are  open  projects, and  community
contributions are  essential for keeping  them great.  We can’t access  the huge
number  of   platforms  and  myriad   of  hardware,  software,   and  deployment
configurations that  Puppet is intended to  serve so feel free  to contribute on
GitHub.

Thanks https://github.com/puppetlabs/ for help to write this README :)
