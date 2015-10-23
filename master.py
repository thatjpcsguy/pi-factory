from flask import Flask, request, jsonify, render_template, redirect, send_from_directory
import json
import cPickle as pickle
import os
import datetime

import sqlite3
from flask import g

app = Flask(__name__)

def make_dicts(cursor, row):
    return dict((cursor.description[idx][0], value)
                for idx, value in enumerate(row))

def connect_db():
    return sqlite3.connect('clients.db')

@app.before_request
def before_request():
    g.db = connect_db()
    g.db.row_factory = make_dicts


@app.teardown_request
def teardown_request(exception):
    if hasattr(g, 'db'):
        g.db.commit()
        g.db.close()

def query_db(query, args=(), one=False):
    cur = g.db.execute(query, args)
    rv = cur.fetchall()
    return (rv[0] if rv else None) if one else rv


@app.route('/clients')
def r():
    return redirect('/', 302)

@app.route('/')
def clients():
    clients = query_db('''SELECT client_id, url, name, ip_address, 
        CASE WHEN last_seen > datetime(current_timestamp, '-4 minute') THEN 'online' ELSE 'offline' END as online from clients ORDER BY name DESC''')
    print clients

    offline = datetime.datetime.now() - datetime.timedelta(minutes=4)

    return render_template('clients.html', clients=clients, offline=offline)

@app.route('/register/<client_id>')
def register(client_id):
    query_db('''INSERT OR REPLACE INTO clients (client_id, ip_address, last_seen) 
        VALUES (?, ?, current_timestamp)''', [client_id, request.args.get('ip')])

    client = query_db('SELECT * FROM clients WHERE client_id = ?', [client_id], one=True)

    clients = query_db('SELECT * from clients ORDER BY name DESC')
    print clients

    return jsonify(client)


@app.route('/update-url/<client_id>')
def update_url(client_id):
    query_db('UPDATE clients SET url = ? WHERE client_id = ?', [request.args.get('url'), client_id])
    client = query_db('SELECT * FROM clients WHERE client_id = ?', [client_id], one=True)
    os.system('ssh -o "StrictHostKeyChecking no" pi@' + client['ip_address'] + ' "./refresh.sh" &')
    return redirect('/', 302)

@app.route('/update-name/<client_id>')
def update_name(client_id):
    query_db('UPDATE clients SET name = ? WHERE client_id = ?', [request.args.get('name'), client_id])
    return redirect('/', 302)

@app.route('/text/<word>')
def word(word):
    return render_template('word.html', word=word)

@app.route('/remove/<client_id>')
def remove(client_id):
    query_db('DELETE FROM clients WHERE client_id = ?', [client_id])
    return redirect('/', 302)


@app.route('/action/<client_id>/reboot')
def reboot(client_id, action):
    client = query_db('SELECT * FROM clients WHERE client_id = ?', [client_id], one=True)
    os.system('ssh -o "StrictHostKeyChecking no" pi@' + client['ip_address'] + ' "sudo reboot -n" &')

    return redirect('/', 302)


@app.route('/init')
def init():
    return send_from_directory(app.static_folder, 'init.sh')



@app.route('/anti-gandalf')
def anti_gandalf():
    for i in query_db('SELECT * from clients ORDER BY name DESC'):
        os.system('ssh -o "StrictHostKeyChecking no" pi@' + i['ip_address'] + ' "./refresh.sh" &')
    return redirect('/', 302)


@app.route('/gandalf-button')
def gandalf_button():
    for i in query_db('SELECT * from clients ORDER BY name DESC'):
        os.system('ssh -o "StrictHostKeyChecking no" pi@' + i['ip_address'] + ' "./gandalf.sh" &')
    return redirect('/', 302)

@app.route('/reboot-all')
def reboot_all():
    for i in query_db('SELECT * from clients ORDER BY name DESC'):
        os.system('ssh -o "StrictHostKeyChecking no" pi@'+ i['ip_address']+' "sudo reboot -n" &')
    return redirect('/', 302)


@app.route('/gandalf')
def gandalf():
    return render_template('gandalf.html')


if __name__ == "__main__":
    app.run(port=8000, debug=True, host="0.0.0.0")
