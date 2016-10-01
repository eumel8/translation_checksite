Translation_checksite for OpenStack I18N
========================================

This puppet module provides environment for check translation in OpenStack

Features
--------
- Install Cron for Zanata Sync

Requirements
------------

For installing Zanata Client:

https://github.com/puppetlabs/puppetlabs-java_ks.git

https://git.openstack.org/openstack-infra/puppet-zanata


Prerequisites for installing Zanata CLI
---------------------------------------

    user { "ubuntu":
      ensure     => 'present',
      uid        => 1000,
      groups     => 'ubuntu',
      comment    => "Ubuntu User",
      managehome => false,
      shell      => '/bin/bash',
      password   => '*',
    }
    ->
    file { '/home/ubuntu/.config':
      ensure  => directory,
    }
    class {'zanata::client':
      version        => '3.8.1',
      user           => 'ubuntu',
      group          => 'ubuntu',
      server         => 'openstack',
      server_url     => 'https://translate.openstack.org:443',
      server_user    => 'user',
      server_api_key => '12345',
      homedir        => '/home/ubuntu/',
    }

Usage
-----

Install DevStack without any plugins:

    class {'translation_checksite':
      project_version   => "stable-newton",  # used version in Zanata Project
    }

Install Translation Checksite with parameter:

    class {'translation_checksite':
      zanata_cli        => "/opt/zanata/zanata-cli-3.8.1/bin/zanata-cli",
      devsstack_dir     => "/home/ubuntu/devstack2",
      stack_user        => "ubuntu",
      project_version   => "master",
      sync_hour         => 18,
      sync_minute       => 30
    }

Note: Developed for Ubuntu 14.04 LTS
