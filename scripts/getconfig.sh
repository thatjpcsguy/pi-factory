#!/bin/bash

PI_BASE=/var/lib/pimaster

if grep -q domain /etc/resolv.conf; then 
  PI_DC=`cat /etc/resolv.conf | grep domain | cut -d' ' -f2 | tr . -`
else
  PI_DC=`cat /etc/resolv.conf | grep search | cut -d' ' -f2 | tr . -`
fi

PI_NODE=`hostname`

PI_NODE_URL=http://localhost:8500/v1/kv/nodes/$PI_NODE

res=`curl -s -o /dev/null -w '%{http_code}\n' $PI_NODE_URL`
if [ $res == "404" ]; then
    curl -X PUT -d "smoketest\n" $PI_NODE_URL
fi

rm -rf $PI_BASE/config/*

curl -s $PI_NODE_URL\?raw | while read line
do
	curl -s http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/config/$line.json > $PI_BASE/config/$line.json
done

/usr/bin/consul reload
