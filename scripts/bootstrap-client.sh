#!/bin/sh

PI_DC=`cat /etc/resolv.conf | grep domain | cut -d' ' -f2 | tr . -`
PI_NODE=client-`cat /sys/class/net/eth0/address | tr -d ':'`
PI_BASE=/var/lib/pimaster

mkdir -p $PI_BASE/config
chown pi:pi -R $PI_BASE

# Get consul binary
if ! [ -f /usr/bin/consul ]; then
  cd /tmp
  wget -O consul.zip https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_arm.zip
  unzip consul.zip
  mv /tmp/consul /usr/bin/consul
fi;

mkdir -p /tmp/consul
watch "/usr/bin/consul agent -retry-join=pimaster.devices.syd2.internal -config-dir $PI_BASE/config -data-dir /tmp/consul -dc=$PI_DC -node=$PI_NODE" &


if ! [ -f /usr/bin/dig ]; then
	apt-get update
	apt-get install dnsutils
fi;

curl -s http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/getconfig.sh | sh
