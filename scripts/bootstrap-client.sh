#!/bin/sh

PI_DC=`cat /etc/resolv.conf | grep domain | cut -d' ' -f2 | tr . -`

if grep -q domain /etc/resolv.conf; then 
  PI_DC=`cat /etc/resolv.conf | grep domain | cut -d' ' -f2 | tr . -`
else
  PI_DC=`cat /etc/resolv.conf | grep search | cut -d' ' -f2 | tr . -`
fi

if ! [ -f /sys/class/net/eth0/address ]; then
  PI_NODE=pimaster-`cat /sys/class/net/eth0/address | tr -d ':'`
else
  PI_NODE=pimaster-`cat /sys/class/net/eth1/address | tr -d ':'`
fi

PI_BASE=/var/lib/pimaster

mkdir -p $PI_BASE/config
mkdir -p $PI_BASE/data
chown pi:pi -R $PI_BASE

hostname $PI_NODE

# Get consul binary
if ! [ -f /usr/bin/consul ]; then
  cd /tmp
  wget -O consul.zip https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_arm.zip
  unzip consul.zip
  mv /tmp/consul /usr/bin/consul
fi;

watch "/usr/bin/consul agent -retry-join=pimaster.devices.syd2.internal -config-dir $PI_BASE/config -data-dir $PI_BASE/data -dc=$PI_DC -node=$PI_NODE" &

if ! [ -f /usr/bin/dig ]; then
	apt-get update
	apt-get install dnsutils
fi;

curl -s http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/getconfig.sh | bash
