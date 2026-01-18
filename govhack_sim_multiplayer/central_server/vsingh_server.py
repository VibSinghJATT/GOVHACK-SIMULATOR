import socket, threading, json, uuid, time

HOST = "0.0.0.0"
PORT = 6000

rooms = {
    "VSingh": {
        "password": "",
        "clients": {},
        "pvp": None
    }
}

users = {}  # conn -> username

def broadcast(room, msg):
    for c in rooms[room]["clients"].values():
        try:
            c.send((msg + "\n").encode())
        except:
            pass

def handle_client(conn, addr):
    conn.send(b"CONNECTED TO GOVHACK SERVER\n")
    user = None
    room = None

    while True:
        try:
            data = conn.recv(1024).decode().strip()
            if not data:
                break
        except:
            break

        parts = data.split()
        cmd = parts[0].upper()

        # -------- LOGIN --------
        if cmd == "LOGIN":
            user = parts[1]
            users[conn] = user
            conn.send(f"LOGIN_OK {user}\n".encode())

        # -------- ROOMS --------
        elif cmd == "JOIN":
            room = parts[1]
            if room not in rooms:
                rooms[room] = {"password": "", "clients": {}, "pvp": None}
            rooms[room]["clients"][user] = conn
            broadcast(room, f"[+] {user} joined {room}")

        # -------- CHAT --------
        elif cmd == "CHAT":
            msg = " ".join(parts[1:])
            broadcast(room, f"{user}: {msg}")

        # -------- PVP --------
        elif cmd == "PVP_START":
            rooms[room]["pvp"] = {
                "type": "keypress",
                "target": 30,
                "progress": {}
            }
            broadcast(room, "PVP_STARTED keypress 30")

        elif cmd == "KEY":
            if rooms[room]["pvp"]:
                p = rooms[room]["pvp"]
                p["progress"][user] = p["progress"].get(user, 0) + 1
                if p["progress"][user] >= p["target"]:
                    broadcast(room, f"PVP_WINNER {user}")
                    rooms[room]["pvp"] = None

    if user and room and user in rooms[room]["clients"]:
        del rooms[room]["clients"][user]
        broadcast(room, f"[-] {user} left")

    conn.close()

server = socket.socket()
server.bind((HOST, PORT))
server.listen()

print("VSingh Multiplayer Server running on port", PORT)

while True:
    c, a = server.accept()
    threading.Thread(target=handle_client, args=(c, a), daemon=True).start()
