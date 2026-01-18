# GOVHACK SIMULATOR - Windows 10/11
# Author: VibSingh

function Hash-Port($code){ $sum=0; foreach($c in $code.ToCharArray()){ $sum+=[int][char]$c }; return 40000 + ($sum % 10000) }

function Host-Game{
    $code=Read-Host "Room code (blank=random)"; if($code -eq ""){$code=-join ((48..57 + 65..90)|Get-Random -Count 6|%{[char]$_})}
    $pass=Read-Host "Optional password"
    $port=Hash-Port $code
    Write-Host "Share with friends: Room=$code Port=$port Password=$pass"
    $type=Read-Host "Server type 1) Node 2) Python 3) Direct IP"
    switch($type){1{node node_server.js $code $pass} 2{python python_server.py $code $pass} 3{$listener=[System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any,$port); $listener.Start(); while($true){$client=$listener.AcceptTcpClient()}}}
}

function Join-Game{
    $code=Read-Host "Room code"
    $pass=Read-Host "Password"
    $host=Read-Host "Host IP"
    $port=Hash-Port $code
    $type=Read-Host "Server type 1) Node 2) Python 3) Direct IP"
    switch($type){1{node node_client.js $code $pass $host} 2{python python_client.py $code $pass $host} 3{$client=New-Object System.Net.Sockets.TcpClient($host,$port)}}
}

function Single-Player{Write-Host "Single Player Mini-Games (implement here)"; Start-Sleep 1}

while($true){
    Clear-Host
    Write-Host "1) Single Player"
    Write-Host "2) Multiplayer"
    Write-Host "3) Exit"
    $c=Read-Host ">"
    if($c -eq "1"){Single-Player}
    if($c -eq "2"){Write-Host "Multiplayer"; $mode=Read-Host "Host(H)/Join(J)"; if($mode -eq "H"){Host-Game}else{Join-Game}}
    if($c -eq "3"){exit}
}
