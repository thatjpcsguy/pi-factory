#!/bin/bash

echo "                                                                                                                                                                            ";
echo "                                                                                                                                                                            ";
echo "PPPPPPPPPPPPPPPPP     iiii       FFFFFFFFFFFFFFFFFFFFFF                                            tttt                                                                     ";
echo "P::::::::::::::::P   i::::i      F::::::::::::::::::::F                                         ttt:::t                                                                     ";
echo "P::::::PPPPPP:::::P   iiii       F::::::::::::::::::::F                                         t:::::t                                                                     ";
echo "PP:::::P     P:::::P             FF::::::FFFFFFFFF::::F                                         t:::::t                                                                     ";
echo "  P::::P     P:::::Piiiiiii        F:::::F       FFFFFFaaaaaaaaaaaaa      ccccccccccccccccttttttt:::::ttttttt       ooooooooooo   rrrrr   rrrrrrrrryyyyyyy           yyyyyyy";
echo "  P::::P     P:::::Pi:::::i        F:::::F             a::::::::::::a   cc:::::::::::::::ct:::::::::::::::::t     oo:::::::::::oo r::::rrr:::::::::ry:::::y         y:::::y ";
echo "  P::::PPPPPP:::::P  i::::i        F::::::FFFFFFFFFF   aaaaaaaaa:::::a c:::::::::::::::::ct:::::::::::::::::t    o:::::::::::::::or:::::::::::::::::ry:::::y       y:::::y  ";
echo "  P:::::::::::::PP   i::::i        F:::::::::::::::F            a::::ac:::::::cccccc:::::ctttttt:::::::tttttt    o:::::ooooo:::::orr::::::rrrrr::::::ry:::::y     y:::::y   ";
echo "  P::::PPPPPPPPP     i::::i        F:::::::::::::::F     aaaaaaa:::::ac::::::c     ccccccc      t:::::t          o::::o     o::::o r:::::r     r:::::r y:::::y   y:::::y    ";
echo "  P::::P             i::::i        F::::::FFFFFFFFFF   aa::::::::::::ac:::::c                   t:::::t          o::::o     o::::o r:::::r     rrrrrrr  y:::::y y:::::y     ";
echo "  P::::P             i::::i        F:::::F            a::::aaaa::::::ac:::::c                   t:::::t          o::::o     o::::o r:::::r               y:::::y:::::y      ";
echo "  P::::P             i::::i        F:::::F           a::::a    a:::::ac::::::c     ccccccc      t:::::t    tttttto::::o     o::::o r:::::r                y:::::::::y       ";
echo "PP::::::PP          i::::::i     FF:::::::FF         a::::a    a:::::ac:::::::cccccc:::::c      t::::::tttt:::::to:::::ooooo:::::o r:::::r                 y:::::::y        ";
echo "P::::::::P          i::::::i     F::::::::FF         a:::::aaaa::::::a c:::::::::::::::::c      tt::::::::::::::to:::::::::::::::o r:::::r                  y:::::y         ";
echo "P::::::::P          i::::::i     F::::::::FF          a::::::::::aa:::a cc:::::::::::::::c        tt:::::::::::tt oo:::::::::::oo  r:::::r                 y:::::y          ";
echo "PPPPPPPPPP          iiiiiiii     FFFFFFFFFFF           aaaaaaaaaa  aaaa   cccccccccccccccc          ttttttttttt     ooooooooooo    rrrrrrr                y:::::y           ";
echo "                                                                                                                                                         y:::::y            ";
echo "                                                                                                                                                        y:::::y             ";
echo "                                                                                                                                                       y:::::y              ";
echo "                                                                                                                                                      y:::::y               ";
echo "                                                                                                                                                     yyyyyyy                ";
echo "                                                                                                                                                                            ";
echo "                                                                                                                                                                            ";

sleep 5

server_addr=http://10.117.119.8:8000

#dont ever remove this line
echo "curl -s http://10.117.119.8:8000/init | bash" | sudo tee /etc/rc.local > /dev/null


sudo su pi
cd ~/

curl -s http://10.117.119.8:8000/static/boot.py > boot.py
rm -rf .ssh/
mkdir .ssh/
curl -s http://10.117.119.8:8000/static/ssh_keys > .ssh/authorized_keys
curl -s http://10.117.119.8:8000/static/chrome_prefs > .config/chromium/Default/Preferences


curl -s http://10.117.119.8:8000/static/gandalf.sh > gandalf.sh
chmod +x gandalf.sh

curl -s http://10.117.119.8:8000/static/ping.py > ping.py
curl -s http://10.117.119.8:8000/static/refresh.sh > refresh.sh
curl -s http://10.117.119.8:8000/static/crontab > crontab.txt
crontab crontab.txt

sudo pip install requests
sudo rm .xinitrc

python boot.py

sleep 5

startx

