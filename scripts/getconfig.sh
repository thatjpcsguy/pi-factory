#!/bin/sh

PI_DC=`cat /etc/resolv.conf | grep domain | cut -d' ' -f2 | tr . -`
PI_NODE=client-`cat /sys/class/net/eth0/address | tr -d ':'`
PI_BASE=/var/lib/pimaster

PI_NODE_URL=http://localhost:8500/v1/kv/nodes/$PI_NODE


res=`curl -s -o /dev/null -w '%{http_code}\n' $PI_NODE_URL`
if [ "$res" == "404" ]; then
    curl -X PUT -d 'smoketest
' $PI_NODE_URL
fi


curl -s $PI_NODE_URL\?raw | while read line
do
	curl -s http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/config/$line.json > $PI_BASE/config/
done

/usr/bin/consul reload
