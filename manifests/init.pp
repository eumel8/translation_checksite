# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: translation_checksite
#
# Maintaining environment for translation checksite
#
# === Parameters
#
# === Variables
#
# [*zanata_cli*]
# Location of Zanata Client
#
# [*devstack_dir*]
# Destination of DevStack installation
#
# [*stack_user*]
# Unix user of DecStack installation
#
# [*revision*]
# used branch (check https://github.com/openstack-dev/devstack.git 
# for available branches )
#
# [*project_version*]
# used project version in Zanata (check Zanata for available versions )
#
# [*admin_password*]
# Password of admin (taking care)
#
# [*database_password*]
# Password of databse
#
# [*rabbit_password*]
# Password of RabbitMQ
#
# [*service_password*]
# Password of services
# 
# [*service_token*]
# Password of service token
#
# [*sync_hour*]
# [*sync_minute*]
# configure cron to sync translation files from Zanata
#
# [*shutdown*]
# Shutdown and delete DevStack
#
# === Authors
#
# Frank Kloeker <f.kloeker@telekom.de>
#
#

class translation_checksite (
  $devstack_dir      = "/home/ubuntu/devstack",
  $zanata_cli        = "/opt/zanata/zanata-cli-3.8.1/bin/zanata-cli",
  $stack_user        = "ubuntu",
  $revision          = "master",
  $project_version   = "master",
  $admin_password    = "password",
  $database_password = "password",
  $rabbit_password   = "password",
  $service_password  = "password",  
  $service_token     = "password",
  $sync_hour         = 0,
  $sync_minute       = 0,
  $shutdown          = undef,
) {

  vcsrepo { "$devstack_dir":
    ensure   => present,
    provider => git,
    owner    => "${stack_user}",
    group    => "${stack_user}",
    source   => 'https://github.com/openstack-dev/devstack.git',
    revision => "${revision}",
  }

  file {"${devstack_dir}/local.conf":
    ensure  => file,
    mode    => '0600',
    owner   => "${stack_user}",
    group   => "${stack_user}",
    content => template('translation_checksite/local.conf.erb'),
    force   => true,
    require => [ Vcsrepo["${devstack_dir}"] ],
  }
  ->
  exec { "run_devstack":
    cwd       => $devstack_dir,
    command   => "/bin/su ${stack_user} -c ${devstack_dir}/stack.sh &",
    unless    => "/bin/ps aux | /usr/bin/pgrep stack",
    timeout   => 3600, 
    require   => [ Vcsrepo["${devstack_dir}"] ],
    logoutput => true
  }

  if ($shutdown == 1) {
    exec { "unstack_devstack":
      cwd       => $devstack_dir,
      command   => "/bin/su ${stack_user} -c ${devstack_dir}/unstack.sh &",
      timeout   => 600, 
      logoutput => true
    }
    ->
    exec { "clean_devstack":
      cwd       => $devstack_dir,
      command   => "/bin/su ${stack_user} -c ${devstack_dir}/clean.sh &",
      unless    => "/bin/ps aux | /usr/bin/pgrep stack",
      timeout   => 300, 
      logoutput => true
    }
  }

  file {"${stack_user}/zanata.xml":
    ensure  => file,
    mode    => '0644',
    owner   => "${stack_user}",
    group   => "${stack_user}",
    content => template('translation_checksite/zanata.xml.erb'),
    force   => true,
  }

  cron { 'zanata-sync':
    ensure   => present,
    command  => "/usr/bin/rsync -a --delete /data/vmail/* tewa.eumelvpn.local::data/vmail",
    user     => "${stack_user}",
    hour     => ${sync_hour},
    minute   => ${sync_minute},
  }

}
