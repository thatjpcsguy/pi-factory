import subprocess

WLAN_check_flg = False  # Variable to check what kind of LAN issue we're dealing with
try_WLAN = 1            # Counter to give the system some time to recover by itself


# This function checks if the WLAN is still up by pinging the router.
# If there is no connection, we'll give the system 3 more tries to recover by itself
# before we reset the WLAN connection.
# If that does not work after 3 tries, we need to reboot the Pi.

print "Checking Wifi...",

while True:
    ping_ret = subprocess.call(['ping -c 2 -w 1 -q 10.117.119.8 |grep "1 received" > /dev/null 2> /dev/null'], shell=True)
    if ping_ret:
        # we lost the WLAN connection.
        # the system may recover by itself, so give it some time to do that
        # did we try that already?
        if WLAN_check_flg:
            # we have a serious problem and need to reboot the Pi to recover the WLAN connection

            WLAN_check_flg = False
            try_WLAN = 1
            print "Wifi is buggered.. let's reboot!"

            subprocess.call(['sudo reboot -n'], shell=True)
        else:
            if try_WLAN > 4:
                # try to recover the connection by resetting the WLAN
                if try_WLAN > 8: 
                    WLAN_check_flg = True  # give up, try to recover with a reboot
                subprocess.call(['sudo /sbin/ifdown wlan0 && sleep 10 && sudo /sbin/ifup --force wlan0'], shell=True)
    else:
        break

    try_WLAN += 1

print "All gooooooood!"

