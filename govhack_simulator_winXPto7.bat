@echo off
:: =========================================================
:: GOVHACK SIMULATOR — Old Windows Edition (Batch)
:: Created by VibSingh
:: GitHub: https://github.com/VibSinghJATT & https://github.com/Omgindia1234
:: Works on Windows XP, 7, 8, 10
:: =========================================================

:: ------------------- Setup -------------------
set BASE=%USERPROFILE%\.govhack_simulator
if not exist "%BASE%" mkdir "%BASE%"
if not exist "%BASE%\inventory.txt" type nul > "%BASE%\inventory.txt"
if not exist "%BASE%\highscores.txt" type nul > "%BASE%\highscores.txt"
if not exist "%BASE%\achievements.txt" type nul > "%BASE%\achievements.txt"

:: ------------------- Helpers -------------------
:Pause
echo.
echo Press Enter to continue...
pause >nul
goto :eof

:Beep
echo ^G
goto :eof

:: ------------------- Banner -------------------
:Banner
cls
echo ============================================
echo   GOVHACK SIMULATOR — Windows Edition
echo   Created by VibSingh
echo   GitHub: https://github.com/VibSinghJATT & https://github.com/Omgindia1234
echo ============================================
echo.
goto :eof

:: ------------------- Skill Tree -------------------
set fast_mini=0
set extra_time=0
set boss_reduce=0

:UpgradeSkills
cls
echo 💠 Skill Tree
echo 1) Fast Mini-Game Response (level %fast_mini%)
echo 2) Extra Time (level %extra_time%)
echo 3) Boss Damage Reduction (level %boss_reduce%)
echo 0) Back
set /p sk="Choose skill to upgrade: "
if "%sk%"=="1" set /a fast_mini+=1
if "%sk%"=="2" set /a extra_time+=1
if "%sk%"=="3" set /a boss_reduce+=1
if "%sk%"=="0" goto :Menu
goto :UpgradeSkills

:: ------------------- Mini-Games -------------------
:MathGame
set /a a=%RANDOM% %% 20
set /a b=%RANDOM% %% 20
set /p ans="%a% + %b% = "
set /a sum=a+b
if "%ans%"=="%sum%" (
    echo Correct!
) else (
    call :Caught
)
goto :eof

:TypingGame
set word=SECUREACCESS
set /p input="TYPE: %word% > "
if "%input%"=="%word%" (
    echo Correct!
) else (
    call :Caught
)
goto :eof

:MemoryGame
set /a n=%RANDOM% %% 900 + 100
echo MEMORIZE: %n%
ping -n 3 127.0.0.1 >nul
cls
set /p input="Enter: "
if "%input%"=="%n%" (
    echo Correct!
) else (
    call :Caught
)
goto :eof

:PlayMiniGame
:: %1 = type (math, typing, memory)
if "%1%"=="math" call :MathGame
if "%1%"=="typing" call :TypingGame
if "%1%"=="memory" call :MemoryGame
echo %1 >> "%BASE%\replay.txt"
goto :eof

:Boss
:: %1 = Boss Name
call :Cutscene BOSS: %1
call :PlayMiniGame math
call :PlayMiniGame typing
call :PlayMiniGame memory
echo Defeated %1 >> "%BASE%\achievements.txt"
goto :eof

:: ------------------- Open World -------------------
set Maps[1]=USA Datacenter
set Maps[2]=India Cyber Grid
set Maps[3]=Russia Defense Net
set Maps[4]=China Satellite Hub
set Maps[5]=EU Quantum Exchange

:OpenWorld
cls
echo 🗺 Open World Maps
for /L %%i in (1,1,5) do echo %%i) !Maps[%%i]!
echo 6) Back
set /p mapChoice="Select Map: "
if "%mapChoice%"=="6" goto :Menu
set /a mapIndex=%mapChoice%
set MAP=!Maps[%mapIndex%]!
call :Cutscene Entering %MAP%
call :Mission %MAP%
goto :OpenWorld

:Mission
:: %1 = Map Name
set MAP=%1
call :PlayMiniGame math
call :PlayMiniGame typing
call :PlayMiniGame memory
call :Boss AI %MAP%
echo %USERNAME%:1000 >> "%BASE%\highscores.txt"
echo Completed mission at %MAP% >> "%BASE%\achievements.txt"
goto :eof

:Cutscene
:: %1 = Text
cls
echo 🎬 %1
ping -n 2 127.0.0.1 >nul
goto :eof

:Caught
cls
call :Beep
echo 🚨 TRACE COMPLETE — CAUGHT 🚨
call :Pause
exit
goto :eof

:: ------------------- Inventory -------------------
:ViewInventory
cls
echo 📦 Inventory:
type "%BASE%\inventory.txt"
call :Pause
goto :eof

:: ------------------- Fun Commands -------------------
:FunCommands
cls
echo 💻 Fun Commands Menu
echo 1) Rainbow Text
echo 2) Matrix Effect
echo 3) Back
set /p fchoice="> "
if "%fchoice%"=="1" (
    set text=GOVHACK SIMULATOR
    setlocal enabledelayedexpansion
    set colors=0 1 2 3 4 5 6 7
    for /L %%i in (0,1,16) do (
        set /a c=!random! %% 8
        set ch=!text:~%%i,1!
        echo !ch!
    )
    endlocal
    call :Pause
    goto FunCommands
)
if "%fchoice%"=="2" (
    for /L %%i in (1,1,10) do (
        set line=
        for /L %%j in (1,1,50) do (
            set /a r=!random! %% 26 + 65
            set line=!line!!r!
        )
        echo !line!
    )
    call :Pause
    goto FunCommands
)
if "%fchoice%"=="3" goto :Menu
goto FunCommands

:: ------------------- Scores -------------------
:ViewScores
cls
echo Highscores:
type "%BASE%\highscores.txt"
echo.
echo Achievements:
type "%BASE%\achievements.txt"
call :Pause
goto :eof

:: ------------------- Main Menu -------------------
call :Banner
set /p USER="OPERATOR NAME > "
if "%USER%"=="" set USER=anonymous

:Menu
cls
echo 1) Single Player
echo 2) Skill Tree
echo 3) Inventory
echo 4) Fun Commands
echo 5) Scores & Achievements
echo 6) Exit
set /p c="> "
if "%c%"=="1" call :OpenWorld
if "%c%"=="2" call :UpgradeSkills
if "%c%"=="3" call :ViewInventory
if "%c%"=="4" call :FunCommands
if "%c%"=="5" call :ViewScores
if "%c%"=="6" echo %USER%:1000 >> "%BASE%\highscores.txt" & exit
goto :Menu
