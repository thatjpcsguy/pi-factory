#!/bin/sh

rm -Rf /tmp/consul; mkdir -p /tmp/consul; cd /tmp/consul

if ! [ -f /usr/bin/consul ]; then
  wget -O consul.zip https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_arm.zip
  unzip consul.zip
  mv /tmp/consul/consul /usr/bin/consul
fi;

watch "/usr/bin/consul agent -retry-join=pimaster -data-dir /tmp/consul -dc=`cat /etc/resolv.conf | grep domain | cut -d' ' -f2 | tr . -` -node=client-`cat /sys/class/net/eth0/address | tr -d ':'`" &
