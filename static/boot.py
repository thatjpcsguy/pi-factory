import requests
from uuid import getnode as get_mac
import socket
import time
import os

sleep_time = 5
master_port = '8000'
master_ip = '10.117.119.8'
mac = hex(get_mac())

chrome_url = None
attempts = 1

ip_string = os.popen('ip addr show wlan0 | grep inet').read()
ip = ip_string.split()[1].split('/')[0]

print "Hello! My name is pi."
print "My ip address is " + ip + '!'
print "I will now inform my master."

while True:
    request_string = 'http://' + master_ip + ':' + master_port + '/register/' + mac + '?' + 'ip=' + ip
    r = requests.get(request_string)
    response = r.json()
    if r.status_code is 200:
        if 'url' in response:
            if response['url'] == 'None':
                continue
            print "\n\n"
            print('URL to open will be: ' + response['url'] + '\n')
            chrome_url = response['url']
            print "\n\n"
            break

    time.sleep(sleep_time)

f = open('.xinitrc', 'w+')
f.write('chromium --kiosk --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble ' + chrome_url)



