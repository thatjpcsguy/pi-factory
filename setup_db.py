import sqlite3

conn = sqlite3.connect('clients.db')
print "Opened database successfully";

conn.execute('''CREATE TABLE clients
       (client_id varchar(255) primary key,
       name text,
       last_seen timestamp,
       url text,
       ip_address text);''')

conn.close()
