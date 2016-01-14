#!/bin/bash

sleep 60

gsettings set org.gnome.desktop.session idle-delay 0

PI_NODE=`hostname`
CHROME_URL=`curl -s http://localhost:8500/v1/kv/urls/$PI_NODE?raw`

chromium-browser --window-size=1920,1080 --chrome-frame --window-position=0,0 --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble --app="$CHROME_URL" &
chromium-browser --window-size=1920,1080 --chrome-frame --window-position=0,1080 --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble --app="$CHROME_URL" &


echo `date`" - Chrome Url: $CHROME_URL" > /home/freelancer/log.txt
