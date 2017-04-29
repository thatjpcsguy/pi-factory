#!/bin/bash

# TODO: Determine if this file even works or is used at all,
#       and if not replace with Python version

curl -s http://10.117.119.8:8000/static/cookies.sql > cookies.sql

if ! [ -f /usr/bin/sqlite3 ]; then
	sudo apt-get install -y sqlite3
fi

if ! [ -d /var/lib/pimaster/cookies ]; then
	mkdir -p /var/lib/pimaster/cookies
fi

#GET A DASHBOARD COOKIE AND INSERT IT
echo "DELETE FROM cookies where name = '_oauthproxy';" > /tmp/dashboard_cookie.sql
echo "INSERT INTO cookies (creation_utc, host_key, name, value, path, expires_utc, secure, httponly, last_access_utc, has_expires, persistent, priority, encrypted_value, firstpartyonly) VALUES (" >> /tmp/dashboard_cookie.sql
curl -s http://localhost:8500/v1/kv/cookies/dashboard?raw >> /tmp/dashboard_cookie.sql
echo ");" >> /tmp/dashboard_cookie.sql


if ! [ -f /var/lib/pimaster/cookies/dashboard.sql ]; then
    mv /tmp/dashboard_cookie.sql /var/lib/pimaster/cookies/dashboard.sql
    sqlite3 /home/freelancer/.config/chromium/Default/Cookies < /var/lib/pimaster/cookies/dashboard.sql
    shutdown -r now
fi


DIFF=$(diff /tmp/dashboard_cookie.sql /var/lib/pimaster/cookies/dashboard.sql) 
if [ "$DIFF" != "" ] 
then
    mv /tmp/dashboard_cookie.sql /var/lib/pimaster/cookies/dashboard.sql
    sqlite3 /home/freelancer/.config/chromium/Default/Cookies < /var/lib/pimaster/cookies/dashboard.sql
    shutdown -r now
fi

