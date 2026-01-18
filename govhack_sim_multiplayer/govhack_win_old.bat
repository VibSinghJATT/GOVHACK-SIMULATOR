@echo off
echo GOVHACK SIMULATOR - Old Windows
echo Requires ncat.exe for multiplayer

set /p MODE=Host(H)/Join(J)?
if /I "%MODE%"=="H" goto HOST
if /I "%MODE%"=="J" goto JOIN
exit

:HOST
set /p CODE=Room code (6 chars):
set /p PASS=Optional password:
echo Hosting room %CODE%
echo Share: Room=%CODE% Password=%PASS%
ncat -l 40000
goto END

:JOIN
set /p HOSTIP=Enter host IP:
set /p CODE=Room code:
set /p PASS=Password:
ncat %HOSTIP% 40000
goto END

:END
pause
