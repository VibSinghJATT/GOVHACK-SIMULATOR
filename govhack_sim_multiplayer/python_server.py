import socket, threading
PORT=5000
rooms={}

def handle_client(conn,addr):
    conn.send(b"Room code: "); room=conn.recv(1024).decode().strip().upper()
    conn.send(b"Password: "); pwd=conn.recv(1024).decode().strip()
    if room not in rooms: rooms[room]={"password":pwd,"clients":[]}
    if rooms[room]["password"]!=pwd: conn.send(b"Wrong password"); conn.close(); return
    rooms[room]["clients"].append(conn); broadcast(room,f"{addr} joined")
    while True:
        try: data=conn.recv(1024)
        except: break
        if not data: break
        broadcast(room,data.decode())
    rooms[room]["clients"].remove(conn); broadcast(room,f"{addr} left"); conn.close()

def broadcast(room,msg):
    for c in rooms[room]["clients"]:
        try: c.send((msg+"\n").encode())
        except: pass

s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.bind(('0.0.0.0',PORT))
s.listen()
print("Python server running on",PORT)
while True:
    conn,addr=s.accept()
    threading.Thread(target=handle_client,args=(conn,addr)).start()
