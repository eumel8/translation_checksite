Translation_checksite for OpenStack I18N
========================================

This puppet module provides environment for check translation in OpenStack

Features
--------
- Install and Configure DevStack
- Install Cron for Zanata Sync

Requirements
------------

https://github.com/puppetlabs/puppetlabs-vcsrepo


Usage
-----


Install DevStack with parameter:

    class {'translation_checksite':
      zanata_cli        => "/opt/zanata/zanata-cli-3.8.1/bin/zanata-cli",
      devsstack_dir     => "/home/ubuntu/devstack2",
      stack_user        => "ubuntu",
      revision          => "stable/liberty",
      project_version   => "stable-liberty",
      admin_password    => "12345678",
      database_password => "12121212",
      rabbit_password   => "34343434",
      service_password  => "56565656",
      service_token     => "78787878787878",
      sync_hour         => 18,
      sync_minute       => 30,
      restack           => 1, # refresh DevStack installation
      restack_hour      => 18,
      restack_minute    => 00,
    }

Deinstall DevStack:

    class {'translation_checksite':
      devsstack_dir     => "/home/ubuntu/devstack2",
      stack_user        => "ubuntu",
      shutdown          => 1, # this stops DevStack and deletes the installation
    }

Note: Developed for Ubuntu 14.04 LTS
