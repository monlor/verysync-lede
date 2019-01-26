#!/bin/sh
#2017/05/05 by kenney
#version 0.2

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export verysync_`
conf_Path="$KSROOT/verysync/config"
export HOME=/root

create_conf(){
    if [ ! -d $conf_Path ];then
        $KSROOT/verysync/verysync -generate=$conf_Path >>/tmp/verysync.log
    fi
}
lan_ip=$(uci get network.lan.ipaddr)
weburl="http://$lan_ip:$verysync_port"
get_ipaddr(){
    if [ $verysync_wan_enable == 1 ];then
        ipaddr="0.0.0.0:$verysync_port"
    else
        ipaddr="$lan_ip:$verysync_port"
    fi
    # sed -i "/<gui enabled/{n;s/[0-9.]\{7,15\}:[0-9]\{2,5\}/$ipaddr/g}" $conf_Path/config.xml
}
start_verysync(){
    $KSROOT/verysync/verysync -home="$conf_Path" -gui-address "$ipaddr" -no-browser >>/tmp/verysync.log &
    sleep 10
    #cru d verysync
    #cru a verysync "*/10 * * * * sh $KSROOT/scripts/verysync_config.sh"
    dbus set verysync_webui=$weburl
    if [ -L "/etc/rc.d/S94verysync.sh" ];then 
        rm -rf /etc/rc.d/S97verysync.sh
    fi
    ln -sf $KSROOT/init.d/S97verysync.sh /etc/rc.d/S97verysync.sh
}
stop_verysync(){
    for i in `ps |grep verysync|grep -v grep|grep -v "/bin/sh"|awk -F' ' '{print $1}'`;do
        kill $i
    done
    sleep 2
    #cru d verysync
    if [ -L "/etc/rc.d/S94verysync.sh" ];then 
        rm -rf /etc/rc.d/S97verysync.sh
    fi
    dbus set verysync_webui="--"
}

case $ACTION in
start)
	if [ "$verysync_enable" = "1" ]; then
        create_conf
        get_ipaddr
        start_verysync
	fi
	;;
stop)
	stop_verysync
	;;
*)
    if [ "$verysync_enable" = "1" ]; then
        if [ "`ps|grep verysync|grep -v "/bin/sh"|grep -v grep|wc -l`" != "0" ];then 
            stop_verysync
        fi
        create_conf
        get_ipaddr
        start_verysync
	else
        stop_verysync
    fi
    http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'
	;;
esac
