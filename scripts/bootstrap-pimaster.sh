#!/bin/sh

#
# Assuming we have already cloned this repository to /var/lib/pimaster
#


PI_BASE=/var/lib/pimaster

if grep -q domain /etc/resolv.conf; then 
  PI_DC=`cat /etc/resolv.conf | grep domain | cut -d' ' -f2 | tr . -`
else
  PI_DC=`cat /etc/resolv.conf | grep search | cut -d' ' -f2 | tr . -`
fi

if [ -f /sys/class/net/eth0/address ]; then
  PI_NODE=pimaster-`cat /sys/class/net/eth0/address | tr -d ':'`
else
  PI_NODE=pimaster-`cat /sys/class/net/eth1/address | tr -d ':'`
fi

if [ "`uname -m`" != "x86_64" ]; then 
  chown pi:pi -R $PI_BASE
fi

if ! [ -d $PI_BASE ]; then
	echo "Error: Missing install base, $PI_BASE"
	exit 1
fi;

# Get consul binary
if ! [ -f /usr/bin/consul ]; then
  cd /tmp
  if [ "`uname -m`" == "x86_64" ]; then
    wget -O consul.zip https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_amd64.zip
  else
    wget -O consul.zip https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_arm.zip
  fi
  unzip consul.zip
  mv /tmp/consul /usr/bin/consul
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


if ! [ -f /usr/bin/dig ]; then
  apt-get update
  apt-get install dnsutils
fi;

# Set up consul as a daemon in rc local

echo '#!/bin/sh' > /etc/rc.local
echo '' >> /etc/rc.local
echo 'sleep 15' >> /etc/rc.local
echo "/usr/bin/consul agent -data-dir $PI_BASE/data -config-dir $PI_BASE/config -dc=$PI_DC -ui-dir $PI_BASE/web -client=0.0.0.0 -bootstrap-expect 1 -node=$PI_NODE -server &" >> /etc/rc.local
echo 'curl -s http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/getconfig.sh | bash' >> /etc/rc.local
echo 'exit 0;' >> /etc/rc.local

