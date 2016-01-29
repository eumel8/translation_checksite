Translation_checksite for OpenStack I18N
========================================

This puppet module provides environment for check translation in OpenStack

Features
--------
- Install and Configure DevStack

Requirements
------------

https://github.com/puppetlabs/puppetlabs-vcsrepo


Usage
-----


Install DevStack with parameter:

    class {'translation_checksite':
      devsstack_dir     => "/home/ubuntu/devstack2",
      stack_user        => "ubuntu",
      revision          => "stable/liberty",
      admin_password    => "12345678",
      database_password => "12121212",
      rabbit_password   => "34343434",
      service_password  => "56565656",
      service_token     => "78787878787878",

    }


Note: Developed for Ubuntu 14.04 LTS
