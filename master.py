from flask import Flask, request, jsonify, render_template, redirect, send_from_directory
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

    os.system('ssh -o "StrictHostKeyChecking no" pi@' + clients[client_id]['ip_address'] + ' "sudo pkill -f /usr/bin/X; python boot.py; startx;" &')

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
    return send_from_directory(app.static_folder, 'init.sh')


@app.route('/gandalf-button')
def gandalf_button():
    clients = load_db()
    for i in clients:
        os.system('ssh -o "StrictHostKeyChecking no" pi@'+ clients[i]['ip_address']+' "./gandalf.sh" &')
    return redirect('/clients', 302)

@app.route('/reboot-all')
def reboot_all():
    clients = load_db()
    for i in clients:
        os.system('ssh -o "StrictHostKeyChecking no" pi@'+ clients[i]['ip_address']+' "sudo reboot -n" &')
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
    app.run(port=8000, debug=True, host="0.0.0.0")
