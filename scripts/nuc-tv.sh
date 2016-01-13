if ! [ -f /usr/bin/chromium-browser ]; then  
    sudo apt-get update
    echo "Fetching Chromium..."
    sudo apt-get install -y chromium-browser
else
	echo "Chromium Already Exists"
fi


