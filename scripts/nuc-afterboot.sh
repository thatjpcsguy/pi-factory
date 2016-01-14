#!/bin/bash

sleep 60

PI_NODE=`hostname`
CHROME_URL=`curl -s http://localhost:8500/v1/kv/urls/$PI_NODE?raw`

chromium-browser --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble --kiosk $CHROME_URL &

echo "Chrome Url: $CHROME_URL" >> /home/freelancer/log.txt

