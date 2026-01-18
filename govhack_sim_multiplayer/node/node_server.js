const net = require("net");

const PORT = 7000;
let clients = [];

const server = net.createServer(socket => {
  clients.push(socket);
  socket.write("CONNECTED TO NODE MATCH SERVER\n");

  socket.on("data", data => {
    clients.forEach(c => {
      if (c !== socket) c.write(data);
    });
  });

  socket.on("end", () => {
    clients = clients.filter(c => c !== socket);
  });
});

server.listen(PORT, () => {
  console.log("Node matchmaking server on", PORT);
});
