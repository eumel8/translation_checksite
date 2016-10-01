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
# [*stack_user*]
# Unix user of DecStack installation
# needs sudo rights without password
#
# [*project_version*]
# used project version in Zanata (check Zanata for available versions )
#
# [*sync_hour*]
# [*sync_minute*]
# configure cron to sync translation files from Zanata
#
# === Authors
#
# Ying Chun Guo <guoyingc@cn.ibm.com>
# KATO Tomoyuki <kato.tomoyuki@jp.fujitsu.com>
# Ian Y. CHoi <ianyrchoi@gmail.com>
# Akihiro Motoki <amotoki@gmail.com>
# Frank Kloeker <f.kloeker@telekom.de>
#
#

class translation_checksite (
  $zanata_cli        = '/opt/zanata/zanata-cli-3.8.1/bin/zanata-cli',
  $stack_user        = 'ubuntu',
  $project_version   = 'master',
  $sync_hour         = 1,
  $sync_minute       = 0,
) {

# !!! possible usage for openstack-ansible
#
#  vcsrepo { $devstack_dir:
#    ensure   => present,
#    provider => git,
#    owner    => $stack_user,
#    group    => $stack_user,
#    source   => 'https://git.openstack.org/openstack-dev/devstack.git',
#    revision => $revision,
#  }

  file {"/home/${stack_user}/zanata.xml":
    ensure  => file,
    mode    => '0644',
    owner   => $stack_user,
    group   => $stack_user,
    content => template('translation_checksite/zanata.xml.erb'),
    force   => true,
  }

  file {"/home/${stack_user}/zanata-sync.sh":
    ensure  => file,
    mode    => '0755',
    owner   => $stack_user,
    group   => $stack_user,
    content => template('translation_checksite/zanata-sync.sh.erb'),
    force   => true,
  }

  file {"/home/${stack_user}/update-lang-list.py":
    ensure => file,
    mode   => '0755',
    owner  => $stack_user,
    group  => $stack_user,
    source => 'puppet:///modules/translation_checksite/update-lang-list.py',
    force  => true,
  }

  cron { 'zanata-sync':
    ensure      => present,
    environment => 'PATH=/bin:/usr/bin:/usr/local/bin',
    command     => "/home/${stack_user}/zanata-sync.sh",
    user        => $stack_user,
    hour        => $sync_hour,
    minute      => $sync_minute,
  }

}
