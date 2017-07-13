#!/bin/sh

apt-get update
apt-get -y install puppet-common

cat <<EOF > /tmp/osa_install.pp
#!/usr/bin/puppet apply 
node default {

  \$admin_email = 'root@localhost'
  \$branch = 'master'

  exec { 'apt_install_pkg':
    environment  => 'DEBIAN_FRONTEND=noninteractive',
    command      => '/usr/bin/apt-get update; /usr/bin/apt-get -y install python git ansible postfix bsd-mailx',
    unless       => '/usr/bin/test -f /usr/bin/python',
  }

  exec { 'git_clone_osa':
    command => "/usr/bin/git clone -b \${branch} https://github.com/openstack/openstack-ansible /opt/openstack-ansible",
    creates => '/opt/openstack-ansible',
  }

  cron {'zanata-sync':
    ensure  => present,
    command => 'cd /opt/openstack-ansible/playbooks; openstack-ansible os-horizon-install.yml -e "horizon_translations_update=True" --tags "horizon-config"',
    user    => 'root',
    minute  => [01,31],
  }

  exec { 'install_aio':
    cwd     => '/opt/openstack-ansible',
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    command => "bash -c './scripts/gate-check-commit.sh translations'",
    creates => '/etc/openstack_deploy/',
    require => Exec['git_clone_osa'],
    timeout => 0,
  }

  exec { 'send admin password':
    command => "/usr/bin/mail -s '\`grep keystone_auth_admin_password /etc/openstack_deploy/user_secrets.yml\`' \${admin_email}",
    require => Exec['install_aio'],
  }

}
EOF

chmod +x /tmp/osa_install.pp
/tmp/osa_install.pp

# install new ssl cert
# cd /opt/openstack-ansible/playbooks; ansible-playbook haproxy-install.yml -e "haproxy_user_ssl_cert=/etc/ssl/certs/server.crt" -e "haproxy_user_ssl_key=/etc/ssl/private/server.key" -e "haproxy_user_ssl_ca_cert=/etc/ssl/certs/ca.crt"

