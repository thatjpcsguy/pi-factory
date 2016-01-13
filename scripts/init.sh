#!/bin/bash




curl -s http://10.117.119.8:8000/static/gandalf.sh > gandalf.sh
chmod +x gandalf.sh

curl -s http://10.117.119.8:8000/static/cookies.sh | bash

curl -s http://10.117.119.8:8000/static/ping.py > ping.py
curl -s http://10.117.119.8:8000/static/refresh.sh > refresh.sh
chmod +x refresh.sh


sudo rm .xinitrc

python boot.py

sleep 5

startx

