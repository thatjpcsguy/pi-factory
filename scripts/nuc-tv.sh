if ! [ -f /usr/bin/chromium-browser ]; then  
    sudo apt-get update
    echo "Fetching Chromium..."
    sudo apt-get install -y chromium-browser
else
	echo "Chromium Already Exists"
fi

if ! [ -f /etc/lightdm/lightdm.conf ]; then
	echo "Installing Lightdm Config"
	echo "[SeatDefaults]" > /etc/lightdm/lightdm.conf
	echo "autologin-user=freelancer" >> /etc/lightdm/lightdm.conf
	echo "autologin-user-timeout=0" >> /etc/lightdm/lightdm.conf
	echo "autologin-session=lightdm-autologin" >> /etc/lightdm/lightdm.conf
	shutdown -r now
else
	echo "Lightdm Config Exists"
fi


curl -s  http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/chrome_prefs > /home/freelancer/.config/chromium/Default/Preferences
