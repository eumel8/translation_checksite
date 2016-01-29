#!/bin/sh

# fetch new po files for spezific lang
/opt/zanata/zanata-cli-3.8.1/bin/zanata-cli -B -q pull  -l de

# compile mo files
for file in `find trans -name "*.po"` ; do msgfmt -o `echo $file | sed 's/\.po$/.mo/'` $file ; done

# backup curret data
tar cvfz backup_`date +%s`.tgz /opt/stack/horizon/horizon/locale/de/LC_MESSAGES /opt/stack/horizon/openstack_dashboard/locale/de/LC_MESSAGES

# delete staff
rm -f /opt/stack/horizon/horizon/locale/de/LC_MESSAGES/* 
rm -f /opt/stack/horizon/openstack_dashboard/locale/de/LC_MESSAGES/*

# copy new content
cp trans/horizon/locale/* /opt/stack/horizon/horizon/locale/de/LC_MESSAGES/
cp trans/openstack_dashboard/locale/* /opt/stack/horizon/openstack_dashboard/locale/de/LC_MESSAGES/

# reload apache
sudo apache2ctl graceful

