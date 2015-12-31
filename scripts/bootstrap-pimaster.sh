#!/bin/sh

#
# Assuming we have already cloned this repository to /var/lib/pimaster
#


PI_BASE=/var/lib/pimaster
PI_DC=`cat /etc/resolv.conf | grep domain | cut -d' ' -f2 | tr . -`
PI_NODE=pimaster-`cat /sys/class/net/eth0/address | tr -d ':'`

sudo chown pi:pi -R $PI_BASE

if ! [ -d $PI_BASE ]; then
	echo "Error: Missing install base, $PI_BASE"
	exit 1
fi;

# Get consul binary
if ! [ -f /usr/bin/consul ]; then
  cd /tmp
  wget -O consul.zip https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_arm.zip
  unzip consul.zip
  sudo mv /tmp/consul /usr/bin/consul
fi;

# Get the consul web UI
if ! [ -f $PI_BASE/web/index.html ]; then
  cd /tmp
  wget -O web.zip https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_web_ui.zip
  unzip web.zip
  mkdir -p $PI_BASE/web
  mv index.html $PI_BASE/web/
  mv static $PI_BASE/web/
fi;

rm -f $PI_BASE/web/scripts
ln -s $PI_BASE/scripts $PI_BASE/web/scripts # Makes scripts available via the consul web server on port 8500


# Set up consul as a daemon in rc local

sudo su
echo 'mkdir -p /tmp/consul' > /etc/rc.local
echo 'watch "/usr/bin/consul agent -data-dir /tmp/consul -config-dir $PI_BASE/config -dc=$PI_DC -ui-dir $PI_BASE/web -client=0.0.0.0 -bootstrap-expect 1 -node=$PI_NODE -server" &' >> /etc/rc.local
echo 'exit 0;' >> /etc/rc.local

exit
