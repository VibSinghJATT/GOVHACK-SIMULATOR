// Node.js Client
const net=require('net');
const ROOM=process.argv[2], PASS=process.argv[3], HOST=process.argv[4]||'127.0.0.1';
const PORT=5000;
const client=net.connect(PORT,HOST,()=>{ console.log("Connected to "+HOST+":"+PORT); client.write(ROOM+"\n"); client.write(PASS+"\n"); });
client.on('data', data=>process.stdout.write(data.toString()));
const readline=require('readline').createInterface({input:process.stdin,output:process.stdout});
readline.on('line', line=>client.write(line+"\n"));
