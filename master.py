from flask import Flask, request, jsonify
import json
import cPickle as pickle
import os
import datetime

app = Flask(__name__)

storage_file = "clients.db"

@app.route('/ping/<client_id>', methods=['GET', 'POST'])
def ping(client_id):
    if os.path.isfile(storage_file):
        clients = pickle.load(open(storage_file, "rW"))
    else:
        clients = {}
    
    if client_id not in clients:
        clients[client_id] = {'mac_address': client_id}

    clients[client_id]['ip_address'] = request.args.get('ip')
    clients[client_id]['last_time'] = datetime.datetime.now()


    pickle.dump(clients, open(storage_file, "wb"))

    print clients[client_id]

    return jsonify(clients[client_id])





if __name__ == "__main__":
    app.run(port=4000, debug=True, host="0.0.0.0")
