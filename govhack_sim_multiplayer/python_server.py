# Python Multiplayer Server
import socket, threading

PORT_BASE = 40000
rooms = {}  # {roomCode: {"password": pwd, "clients": []}}

def hash_port(code):
    return PORT_BASE + sum(ord(c) for c in code) % 10000

def handle_client(conn, addr):
    conn.send(b"Enter room code: ")
    room = conn.recv(1024).decode().strip().upper()
    conn.send(b"Enter password (or blank): ")
    pwd = conn.recv(1024).decode().strip()
    if room not in rooms:
        rooms[room] = {"password": pwd, "clients": []}
    if rooms[room]["password"] != pwd:
        conn.send(b"Wrong password\n")
        conn.close()
        return
    rooms[room]["clients"].append(conn)
    broadcast(room, f"{addr} joined")
    while True:
        try:
            data = conn.recv(1024)
            if not data: break
            broadcast(room, data.decode().strip())
        except: break
    rooms[room]["clients"].remove(conn)
    broadcast(room, f"{addr} left")
    conn.close()

def broadcast(room, msg):
    for c in rooms[room]["clients"]:
        try: c.send(msg.encode() + b"\n")
        except: pass

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(('0.0.0.0', 5000))
server.listen()
print("Python Multiplayer Server running on port 5000")
while True:
    conn, addr = server.accept()
    threading.Thread(target=handle_client, args=(conn, addr)).start()
