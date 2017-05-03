#!/bin/bash

if ! [ -f /usr/bin/chromium-browser ]; then
    sudo apt-get update
    echo "Fetching Chromium..."
    sudo apt-get install -y chromium-browser
else
	echo "Chromium Already Exists"
fi

if ! [ -f /usr/bin/x11vnc ]; then
	sudo apt-get update
	echo "Fetching x11vnc"
	sudo apt-get install -y x11vnc-data
	sudo apt-get install -y x11vnc
fi

PI_NODE=`hostname`
PI_NODE_URL=http://localhost:8500/v1/kv/urls/$PI_NODE

res=`curl -s -o /dev/null -w '%{http_code}\n' $PI_NODE_URL/1`
if [ "$res" == "404" ]; then
    curl -X PUT -d 'https://dashboard.freelancer.com/tv/revenue_2.html' $PI_NODE_URL/1
fi
