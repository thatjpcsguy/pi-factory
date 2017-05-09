#!/bin/bash

sleep 60

PI_BASE=/var/lib/pimaster

gsettings set org.gnome.desktop.session idle-delay 0

PI_NODE=`hostname`
CHROME_URL_1=`curl -s http://localhost:8500/v1/kv/urls/$PI_NODE/1?raw`
CHROME_URL_2=`curl -s http://localhost:8500/v1/kv/urls/$PI_NODE/2?raw`

mkdir -p $PI_BASE/tmp/chrome1/Default/
mkdir -p $PI_BASE/tmp/chrome2/Default/

curl -s http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/Cookies > $PI_BASE/tmp/chrome1/Default/Cookies
curl -s http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/Cookies > $PI_BASE/tmp/chrome2/Default/Cookies

chromium-browser --window-size=640,480 --chrome-frame --window-position=0,0 --user-data-dir=$PI_BASE/tmp/chrome1 --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble --kiosk --app="$CHROME_URL_1" &
sleep 1
chromium-browser --window-size=640,480 --chrome-frame --window-position=1920,0 --user-data-dir=$PI_BASE/tmp/chrome2 --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble --kiosk --app="$CHROME_URL_2" &

x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbport 5900 -shared -ncache 10 &

echo `date`" - Chrome Url 1: $CHROME_URL_1" > $PI_BASE/tmp/log.txt
echo `date`" - Chrome Url 2: $CHROME_URL_2" >> $PI_BASE/tmp/log.txt
