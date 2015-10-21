import requests
from uuid import getnode as get_mac

import time
import os

mac = hex(get_mac())

ip_string = os.popen('ip addr show wlan0 | grep inet').read()
ip = ip_string.split()[1].split('/')[0]

request_string = 'http://10.117.119.8:8000/register/' + mac + '?' + 'ip=' + ip + '&ping=true'
r = requests.get(request_string)
