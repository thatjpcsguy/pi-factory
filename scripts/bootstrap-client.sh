#!/bin/sh

PI_DC=`cat /etc/resolv.conf | grep domain | cut -d' ' -f2 | tr . -`
PI_NODE=client-`cat /sys/class/net/eth0/address | tr -d ':'`

# Get consul binary
if ! [ -f /usr/bin/consul ]; then
  cd /tmp
  wget -O consul.zip https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_arm.zip
  unzip consul.zip
  mv /tmp/consul /usr/bin/consul
fi;




mkdir -p /tmp/consul
watch "/usr/bin/consul agent -retry-join=pimaster -data-dir /tmp/consul -dc=$PI_DC -node=$PI_NODE" &
