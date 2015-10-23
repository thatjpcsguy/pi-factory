#!/bin/bash

echo "                                                                                                                                                                                                     ";
echo "                                                     ''''''                                                                                                                                          ";
echo "MMMMMMMM               MMMMMMMM          JJJJJJJJJJJ '::::'                      BBBBBBBBBBBBBBBBB                     kkkkkkkk                                                                      ";
echo "M:::::::M             M:::::::M          J:::::::::J '::::'                      B::::::::::::::::B                    k::::::k                                                                      ";
echo "M::::::::M           M::::::::M          J:::::::::J ':::''                      B::::::BBBBBB:::::B                   k::::::k                                                                      ";
echo "M:::::::::M         M:::::::::M          JJ:::::::JJ':::'                        BB:::::B     B:::::B                  k::::::k                                                                      ";
echo "M::::::::::M       M::::::::::M            J:::::J  ''''       ssssssssss          B::::B     B:::::B  aaaaaaaaaaaaa    k:::::k    kkkkkkk eeeeeeeeeeee    rrrrr   rrrrrrrrryyyyyyy           yyyyyyy";
echo "M:::::::::::M     M:::::::::::M            J:::::J           ss::::::::::s         B::::B     B:::::B  a::::::::::::a   k:::::k   k:::::kee::::::::::::ee  r::::rrr:::::::::ry:::::y         y:::::y ";
echo "M:::::::M::::M   M::::M:::::::M            J:::::J         ss:::::::::::::s        B::::BBBBBB:::::B   aaaaaaaaa:::::a  k:::::k  k:::::ke::::::eeeee:::::eer:::::::::::::::::ry:::::y       y:::::y  ";
echo "M::::::M M::::M M::::M M::::::M            J:::::j         s::::::ssss:::::s       B:::::::::::::BB             a::::a  k:::::k k:::::ke::::::e     e:::::err::::::rrrrr::::::ry:::::y     y:::::y   ";
echo "M::::::M  M::::M::::M  M::::::M            J:::::J          s:::::s  ssssss        B::::BBBBBB:::::B     aaaaaaa:::::a  k::::::k:::::k e:::::::eeeee::::::e r:::::r     r:::::r y:::::y   y:::::y    ";
echo "M::::::M   M:::::::M   M::::::MJJJJJJJ     J:::::J            s::::::s             B::::B     B:::::B  aa::::::::::::a  k:::::::::::k  e:::::::::::::::::e  r:::::r     rrrrrrr  y:::::y y:::::y     ";
echo "M::::::M    M:::::M    M::::::MJ:::::J     J:::::J               s::::::s          B::::B     B:::::B a::::aaaa::::::a  k:::::::::::k  e::::::eeeeeeeeeee   r:::::r               y:::::y:::::y      ";
echo "M::::::M     MMMMM     M::::::MJ::::::J   J::::::J         ssssss   s:::::s        B::::B     B:::::Ba::::a    a:::::a  k::::::k:::::k e:::::::e            r:::::r                y:::::::::y       ";
echo "M::::::M               M::::::MJ:::::::JJJ:::::::J         s:::::ssss::::::s     BB:::::BBBBBB::::::Ba::::a    a:::::a k::::::k k:::::ke::::::::e           r:::::r                 y:::::::y        ";
echo "M::::::M               M::::::M JJ:::::::::::::JJ          s::::::::::::::s      B:::::::::::::::::B a:::::aaaa::::::a k::::::k  k:::::ke::::::::eeeeeeee   r:::::r                  y:::::y         ";
echo "M::::::M               M::::::M   JJ:::::::::JJ             s:::::::::::ss       B::::::::::::::::B   a::::::::::aa:::ak::::::k   k:::::kee:::::::::::::e   r:::::r                 y:::::y          ";
echo "MMMMMMMM               MMMMMMMM     JJJJJJJJJ                sssssssssss         BBBBBBBBBBBBBBBBB     aaaaaaaaaa  aaaakkkkkkkk    kkkkkkk eeeeeeeeeeeeee   rrrrrrr                y:::::y           ";
echo "                                                                                                                                                                                  y:::::y            ";
echo "                                                                                                                                                                                 y:::::y             ";
echo "                                                                                                                                                                                y:::::y              ";
echo "                                                                                                                                                                               y:::::y               ";
echo "                                                                                                                                                                              yyyyyyy                ";
echo "                                                                                                                                                                                                     ";
echo "                                                                                                                                                                                                     ";
echo "                                                                                                                                                                                                     ";
echo "                                                                                                                                                                                                     ";


sleep 5

sudo su pi
cd ~/

#dont ever remove this line
curl -s http://10.117.119.8:8000/static/wifi.py > wifi.py
echo "python /home/pi/wifi.py; curl -s http://10.117.119.8:8000/init | bash" | sudo tee /etc/rc.local > /dev/null

curl -s http://10.117.119.8:8000/static/wifi.py | sudo tee /etc/network/interfaces > /dev/null


curl -s http://10.117.119.8:8000/static/boot.py > boot.py
rm -rf .ssh/
mkdir .ssh/
curl -s http://10.117.119.8:8000/static/ssh_keys > .ssh/authorized_keys
curl -s http://10.117.119.8:8000/static/chrome_prefs > .config/chromium/Default/Preferences


curl -s http://10.117.119.8:8000/static/gandalf.sh > gandalf.sh
chmod +x gandalf.sh

curl -s http://10.117.119.8:8000/static/cookies.sh | bash

curl -s http://10.117.119.8:8000/static/ping.py > ping.py
curl -s http://10.117.119.8:8000/static/refresh.sh > refresh.sh
chmod +x refresh.sh

curl -s http://10.117.119.8:8000/static/crontab > crontab.txt
crontab crontab.txt

sudo pip -q install requests
sudo rm .xinitrc

python boot.py

sleep 5

startx

