#!/bin/bash

sleep 60

gsettings set org.gnome.desktop.session idle-delay 0

PI_NODE=`hostname`
CHROME_URL_1=`curl -s http://localhost:8500/v1/kv/urls/$PI_NODE/1?raw`
CHROME_URL_2=`curl -s http://localhost:8500/v1/kv/urls/$PI_NODE/2?raw`

mkdir -p /tmp/chrome1
mkdir -p /tmp/chrome2
chromium-browser --window-size=640,480 --chrome-frame --window-position=0,0 --user-data-dir=/tmp/chrome1 --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble --kiosk --app="$CHROME_URL_1" &
sleep 1
chromium-browser --window-size=640,480 --chrome-frame --window-position=1920,0 --user-data-dir=/tmp/chrome2 --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble --kiosk --app="$CHROME_URL_2" &

#x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbport 5900 -shared -ncache 10 &

echo `date`" - Chrome Url 1: $CHROME_URL_1" > /home/freelancer/log.txt
echo `date`" - Chrome Url 2: $CHROME_URL_2" >> /home/freelancer/log.txt
