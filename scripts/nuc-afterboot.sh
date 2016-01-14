#!/bin/bash

sleep 60

gsettings set org.gnome.desktop.session idle-delay 0

PI_NODE=`hostname`
CHROME_URL=`curl -s http://localhost:8500/v1/kv/urls/$PI_NODE?raw`

mkdir -p /tmp/chrome1
mkdir -p /tmp/chrome2
chromium-browser --window-size=640,480 --chrome-frame --window-position=0,0 --user-data-dir=/tmp/chrome1 --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble --app="$CHROME_URL" &
sleep 10
chromium-browser --window-size=640,480 --chrome-frame --window-position=600,400 --user-data-dir=/tmp/chrome2 --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble --app="$CHROME_URL" &


echo `date`" - Chrome Url: $CHROME_URL" > /home/freelancer/log.txt
