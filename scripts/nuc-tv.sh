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



if ! [ -f /home/freelancer/.config/autostart/chrome.desktop ]; then
	echo "[Desktop Entry]" > /home/freelancer/.config/autostart/chrome.desktop
	echo "Type=Application" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Exec=chromium-browser --kiosk https://www.freelancer.com" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Hidden=false" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "NoDisplay=false" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "X-GNOME-Autostart-enabled=true" >> /home/freelancer/.config/autostart/chrome.desktop
	echo "Name=Start Chrome" >> /home/freelancer/.config/autostart/chrome.desktop
	shutdown -r now
fi


if [ -f /home/freelancer/.config/chromium/Default/Preferences ]; then
	curl -s  http://`dig @127.0.0.1 -p 8600 consul.service.consul +short`:8500/ui/scripts/chrome_prefs > /home/freelancer/.config/chromium/Default/Preferences
fi