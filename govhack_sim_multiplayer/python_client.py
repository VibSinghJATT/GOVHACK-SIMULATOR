import socket, threading, sys
ROOM=sys.argv[1]; PASS=sys.argv[2]; HOST=sys.argv[3] if len(sys.argv)>3 else '127.0.0.1'
PORT=5000
s=socket.socket(); s.connect((HOST,PORT))
s.sendall((ROOM+"\n").encode()); s.sendall((PASS+"\n").encode())
def listen(): 
    while True: print(s.recv(1024).decode(),end='')
threading.Thread(target=listen,daemon=True).start()
while True: s.sendall((input()+"\n").encode())
