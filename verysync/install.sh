#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

cp -r /tmp/verysync/* $KSROOT/
chmod a+x $KSROOT/verysync/verysync
chmod a+x $KSROOT/scripts/verysync_*
chmod a+x $KSROOT/init.d/S97verysync.sh

# add icon into softerware center
dbus set softcenter_module_verysync_install=1
dbus set softcenter_module_verysync_version=0.1
dbus set softcenter_module_verysync_name=verysync
dbus set softcenter_module_verysync_title=verysync
dbus set softcenter_module_verysync_description="轻松搭建私有云"
rm -rf $KSROOT/install.sh

# apply aliddns
sh $KSROOT/scripts/verysync_config.sh start