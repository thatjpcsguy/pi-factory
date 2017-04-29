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

if ! [ -f /etc/lightdm/lightdm.conf ]; then
	echo "Installing Lightdm Config"
	echo "[SeatDefaults]" > /etc/lightdm/lightdm.conf
	echo "autologin-user=freelancer" >> /etc/lightdm/lightdm.conf
	echo "autologin-user-timeout=0" >> /etc/lightdm/lightdm.conf
	echo "autologin-session=lightdm-autologin" >> /etc/lightdm/lightdm.conf
	shutdown -r now
else
	echo "[SeatDefaults]" > /etc/lightdm/lightdm.conf
	echo "autologin-user=freelancer" >> /etc/lightdm/lightdm.conf
	echo "autologin-user-timeout=0" >> /etc/lightdm/lightdm.conf
	echo "autologin-session=lightdm-autologin" >> /etc/lightdm/lightdm.conf
	echo "Lightdm Config Exists"
fi

PI_NODE=`hostname`

PI_NODE_URL=http://localhost:8500/v1/kv/urls/$PI_NODE

res=`curl -s -o /dev/null -w '%{http_code}\n' $PI_NODE_URL/1`
if [ "$res" == "404" ]; then
    curl -X PUT -d 'https://dashboard.freelancer.com/tv/revenue_2.html' $PI_NODE_URL/1
fi

res=`curl -s -o /dev/null -w '%{http_code}\n' $PI_NODE_URL/2`
if [ "$res" == "404" ]; then
    curl -X PUT -d 'https://dashboard.freelancer.com/tv/revenue_2.html' $PI_NODE_URL/2
fi

if ! [ -d /home/freelancer/.config/autostart ]; then
	mkdir -p /home/freelancer/.config/autostart
	chmod -R 777 /home/freelancer/.config/autostart
fi

if ! [ -f /var/lib/pimaster/scripts/nuc-afterboot.sh ]; then
	mkdir -p /var/lib/pimaster/scripts/
	curl -s  http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/nuc-afterboot.sh > /var/lib/pimaster/scripts/nuc-afterboot.sh
	chmod a+rwx /var/lib/pimaster/scripts/nuc-afterboot.sh
	shutdown -r now
fi

if ! [ -f /home/freelancer/.config/autostart/chrome.desktop ]; then
	echo "[Desktop Entry]" > /home/freelancer/.config/autostart/chrome.desktop
	echo "Type=Application" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Exec=/var/lib/pimaster/scripts/nuc-afterboot.sh" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Hidden=false" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "NoDisplay=false" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "X-GNOME-Autostart-enabled=true" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Name=Start Chrome" >> /home/freelancer/.config/autostart/chrome.desktop
	shutdown -r now
else
	echo "[Desktop Entry]" > /home/freelancer/.config/autostart/chrome.desktop
	echo "Type=Application" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Exec=/var/lib/pimaster/scripts/nuc-afterboot.sh" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Hidden=false" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "NoDisplay=false" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "X-GNOME-Autostart-enabled=true" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Name=Start Chrome" >> /home/freelancer/.config/autostart/chrome.desktop
fi

# TODO: Figure out why this is commented out
# if [ -f /home/freelancer/.config/chromium/Default/Preferences ]; then
#curl -s  http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/chrome_prefs > /home/freelancer/.config/chromium/Default/Preferences
# fi
