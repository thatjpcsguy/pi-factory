from flask import Flask, request, jsonify, render_template, redirect
import json
import cPickle as pickle
import os
import datetime

app = Flask(__name__)

app.config['STORAGE_FILE'] = "clients.db"

def load_db():
    if os.path.isfile(app.config['STORAGE_FILE']):
        return pickle.load(open(app.config['STORAGE_FILE'], "rW"))
    return {}

def save_db(db):
    pickle.dump(db, open(app.config['STORAGE_FILE'], "wb"))
    return True


@app.route('/clients')
def clients():
    clients = load_db()
    offline = datetime.datetime.now() - datetime.timedelta(minutes=4)
    return render_template('clients.html', clients=clients, offline=offline)

@app.route('/register/<client_id>')
def register(client_id):
    clients = load_db()
    
    if client_id not in clients:
        clients[client_id] = {'mac_address': client_id}

    clients[client_id]['ip_address'] = request.args.get('ip')
    clients[client_id]['last_time'] = datetime.datetime.now()

    save_db(clients)

    if not request.args.get('ping'):
        print ""
        print clients[client_id]
        print ""

    return jsonify(clients[client_id])


@app.route('/update-url/<client_id>')
def update_url(client_id):
    clients = load_db()

    clients[client_id]['url'] = request.args.get('url')

    save_db(clients)
    return redirect('/clients', 302)

@app.route('/update-name/<client_id>')
def update_name(client_id):
    clients = load_db()

    clients[client_id]['name'] = request.args.get('name')

    save_db(clients)
    return redirect('/clients', 302)

@app.route('/text/<word>')
def word(word):
    return render_template('word.html', word=word)

@app.route('/remove/<client_id>')
def remove(client_id):
    clients = load_db()
    clients.pop(client_id, None)
    save_db(clients)
    return redirect('/clients', 302)


@app.route('/action/<client_id>/<action>')
def action(client_id, action):
    clients = load_db()
    
    if action == 'reboot':
        os.system('ssh -o "StrictHostKeyChecking no" pi@' + clients[client_id]['ip_address'] + ' "sudo reboot -n" &')

    save_db(clients)
    return redirect('/clients', 302)


@app.route('/init')
def init():
    server_addr = "http://10.117.119.203:4000"

    return """#!/bin/bash
#dont ever remove this line
echo "curl -s """ + server_addr + """/init | bash" | sudo tee /etc/rc.local > /dev/null


sudo su pi
cd ~/

curl -s """ + server_addr + """/static/boot.py > boot.py
rm -rf .ssh/
mkdir .ssh/
curl -s """ + server_addr + """/static/ssh_keys > .ssh/authorized_keys
curl -s """ + server_addr + """/static/chrome_prefs > .config/chromium/Default/Preferences


curl -s """ + server_addr + """/static/gandalf.sh > gandalf.sh
chmod +x gandalf.sh

curl -s """ + server_addr + """/static/ping.py > ping.py
curl -s """ + server_addr + """/static/refresh.sh > refresh.sh
curl -s """ + server_addr + """/static/crontab > crontab.txt
crontab crontab.txt

sudo pip install requests
sudo rm .xinitrc

python boot.py

startx
"""


@app.route('/gandalf-button')
def gandalf_button():
    clients = load_db()
    for i in clients:
        os.system('ssh pi@'+ clients[i]['ip_address']+' "./gandalf.sh" &')
    return redirect('/clients', 302)

@app.route('/reboot-all')
def reboot_all():
    clients = load_db()
    for i in clients:
        os.system('ssh pi@'+ clients[i]['ip_address']+' "sudo reboot -n" &')
    return redirect('/clients', 302)


@app.route('/gandalf')
def gandalf():
    return """
<style>
html, body {
margin: 0;
padding: 0;
}
img {
    text-align: center;
    width: 1920px;

}

</style>
<img src="http://4.bp.blogspot.com/-fEXyKe5WLmk/UZ0uDdCJrCI/AAAAAAAAL_o/kS5Jzlu7IDE/s400/gandalf.gif" />

"""


if __name__ == "__main__":
    app.run(port=4000, debug=True, host="0.0.0.0")
