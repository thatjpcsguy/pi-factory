#!/bin/bash

sudo pkill -f /usr/bin/X
echo "chromium --kiosk --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble http://10.117.119.8:8000/gandalf" > .xinitrc
startx
