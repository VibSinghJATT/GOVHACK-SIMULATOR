// Node.js Server — Cross-platform
const net = require('net');
const PORT = 5000;
let rooms = {}; // {roomCode: {password, clients: []}}

const server = net.createServer(socket => {
  socket.write("Enter room code: ");
  let roomCode='', password='';
  socket.on('data', data=>{
    let msg=data.toString().trim();
    if(!roomCode){ roomCode=msg.toUpperCase(); socket.write("Password: "); return; }
    if(!password){ password=msg; if(!rooms[roomCode]) rooms[roomCode]={password, clients:[]};
      if(rooms[roomCode].password!==password){ socket.write("Wrong password\n"); socket.end(); return; }
      rooms[roomCode].clients.push(socket); broadcast(roomCode, "User joined");
      return;
    }
    broadcast(roomCode, msg);
  });
  socket.on('close',()=>{ if(rooms[roomCode]) rooms[roomCode].clients=rooms[roomCode].clients.filter(c=>c!==socket); broadcast(roomCode,"User left"); });
});

function broadcast(room,msg){ if(!rooms[room])return; rooms[room].clients.forEach(c=>c.write(msg+"\n")); }
server.listen(PORT,()=>console.log("Node.js server running on "+PORT));
