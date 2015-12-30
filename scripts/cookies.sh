#!/bin/bash

curl -s http://10.117.119.8:8000/static/cookies.sql > cookies.sql

sudo apt-get install -y sqlite3

sqlite3 ~/.config/chromium/Default/Cookies < cookies.sql

