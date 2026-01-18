// Node.js Multiplayer Server
// Author: VibSingh

const net = require('net');
const readline = require('readline');

const PORT_BASE = 40000;
const rooms = {}; // {roomCode: {password, clients: []}}

function hashPort(code) {
  let sum = 0;
  for (let i = 0; i < code.length; i++) sum += code.charCodeAt(i);
  return PORT_BASE + (sum % 10000);
}

const server = net.createServer((socket) => {
  socket.write("Welcome! Enter room code: ");
  let roomCode = '';
  let password = '';

  socket.on('data', (data) => {
    const input = data.toString().trim();
    if (!roomCode) {
      roomCode = input.toUpperCase();
      socket.write("Enter password (or leave blank): ");
    } else if (!password) {
      password = input;
      if (!rooms[roomCode]) {
        rooms[roomCode] = { password, clients: [] };
      }
      if (rooms[roomCode].password !== password) {
        socket.write("Wrong password. Disconnecting.\n");
        socket.end();
        return;
      }
      rooms[roomCode].clients.push(socket);
      broadcast(roomCode, `User joined ${roomCode}`);
    } else {
      broadcast(roomCode, input);
    }
  });

  socket.on('close', () => {
    if (roomCode && rooms[roomCode]) {
      rooms[roomCode].clients = rooms[roomCode].clients.filter(c => c !== socket);
      broadcast(roomCode, "User disconnected");
    }
  });

  function broadcast(room, msg) {
    if (!rooms[room]) return;
    rooms[room].clients.forEach(c => { c.write(msg + "\n"); });
  }
});

server.listen(5000, () => console.log("Node.js Multiplayer Server running on port 5000"));
