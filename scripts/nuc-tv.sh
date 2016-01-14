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


PI_NODE=`hostname`

PI_NODE_URL=http://localhost:8500/v1/kv/urls/$PI_NODE

res=`curl -s -o /dev/null -w '%{http_code}\n' $PI_NODE_URL`
if [ "$res" == "404" ]; then
    curl -X PUT -d 'https://dashboard.freelancer.com/tv/revenue_2.html' $PI_NODE_URL
fi


if ! [ -d /home/freelancer/.config/autostart ]; then
	mkdir -p /home/freelancer/.config/autostart
	chmod -R 777 /home/freelancer/.config/autostart
fi

if ! [ -f /home/freelancer/.config/autostart/chrome.desktop ]; then
	echo "[Desktop Entry]" > /home/freelancer/.config/autostart/chrome.desktop
	echo "Type=Application" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Exec=sleep 30 && chromium-browser --kiosk \`curl -s $PI_NODE_URL?raw\`" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Hidden=false" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "NoDisplay=false" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "X-GNOME-Autostart-enabled=true" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Name=Start Chrome" >> /home/freelancer/.config/autostart/chrome.desktop
	shutdown -r now
else
	echo "[Desktop Entry]" > /home/freelancer/.config/autostart/chrome.desktop
	echo "Type=Application" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Exec=sleep 30 && chromium-browser --ignore-certificate-errors --disable-restore-session-state --disable-infobars --disable-session-crashed-bubble --kiosk \`curl -s $PI_NODE_URL?raw\`" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Hidden=false" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "NoDisplay=false" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "X-GNOME-Autostart-enabled=true" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Name=Start Chrome" >> /home/freelancer/.config/autostart/chrome.desktop
fi


if [ -f /home/freelancer/.config/chromium/Default/Preferences ]; then
	curl -s  http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/chrome_prefs > /home/freelancer/.config/chromium/Default/Preferences
fi

