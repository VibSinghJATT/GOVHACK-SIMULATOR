const net = require("net");
const readline = require("readline");

const client = net.connect(6000, "127.0.0.1");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

client.on("data", data => {
  console.log(data.toString().trim());
});

rl.on("line", line => {
  client.write(line + "\n");
});
