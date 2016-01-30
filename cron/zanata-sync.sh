#!/bin/sh

# fetch new po files for spezific lang
/opt/zanata/zanata-cli-3.8.1/bin/zanata-cli -B -q pull

# working dir (configured in zanata.xml
cd trans

# compile mo files
for file in `find . -name "*.po"` ; do msgfmt -o `echo $file | sed 's/\.po$/.mo/'` $file ; done

# backup curret data
# tar cfz backup_`date +%s`.tgz /opt/stack/horizon/horizon/locale/ /opt/stack/horizon/openstack_dashboard/locale/

# read trans
ls | while read i 

do 

# go to the language directory and copy only exists files into devstack installation
cd $i
for file in $(find . -type f -prune | cut -b3-)
do 
  dfile=`echo "/opt/stack/horizon/$file" | sed "s/\(.*\)\//\1\/$i\/LC_MESSAGES\//"`
  if [ -f $dfile ]; then
    cp $file ${dfile}
  fi
done
cd ..

done

# reload apache
sudo apache2ctl graceful

