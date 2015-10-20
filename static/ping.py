import requests
from uuid import getnode as get_mac

import time
import os

master_port = '4000'
master_ip = '10.117.119.203'
master_lan_ip = '10.117.108.130'
mac = hex(get_mac())

ip_string = os.popen('ip addr show wlan0 | grep inet').read()
ip = ip_string.split()[1].split('/')[0]

if attempts % 10 == 0:
    request_ip = master_lan_ip
else:
    request_ip = master_ip

request_string = 'http://' + request_ip + ':' + master_port + '/register/' + mac + '?' + 'ip=' + ip
r = requests.get(request_string)
