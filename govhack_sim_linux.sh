#!/bin/bash
# =========================================================
# GOVHACK SIMULATOR — Linux Edition
# Created by: VibSingh
# GitHub: https://github.com/VibSinghJATT & https://github.com/Omgindia1234
# Terminal-only, Linux-native, full features
# =========================================================

BASE="$HOME/.govhack_simulator"
MODS="$BASE/mods"
HS="$BASE/highscores.txt"
ACH="$BASE/achievements.txt"
SAVE="$BASE/save.txt"
INV="$BASE/inventory.txt"
REPLAY="$BASE/replay.txt"

mkdir -p "$BASE" "$MODS"
touch "$HS" "$ACH" "$SAVE" "$INV" "$REPLAY"

beep(){ echo -ne "\a"; }
pause(){ read -p "Press Enter..."; }

# ------------------- Banner -------------------
banner(){
clear
cat <<'EOF'
 ██████╗  ██████╗ ██╗   ██╗██╗  ██╗ █████╗  ██████╗██╗  ██╗
██╔════╝ ██╔═══██╗██║   ██║██║  ██║██╔══██╗██╔════╝██║ ██╔╝
██║  ███╗██║   ██║██║   ██║███████║███████║██║     █████╔╝
██║   ██║██║   ██║██║   ██║██╔══██║██╔══██║██║     ██╔═██╗
╚██████╔╝╚██████╔╝╚██████╔╝██║  ██║██║  ██║╚██████╗██║  ██╗
 ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
EOF
echo "GOVHACK SIMULATOR — Linux Edition"
echo "Created by: VibSingh | GitHub: https://github.com/VibSinghJATT & https://github.com/Omgindia1234"
sleep 1
}

# ------------------- Achievements & Inventory -------------------
award(){ grep -qx "$1" "$ACH" || echo "$1" >> "$ACH"; }
add_item(){ echo "$1" >> "$INV"; }
view_inventory(){ clear; echo "📦 Inventory:"; cat "$INV"; pause; }

# ------------------- Mini-Games -------------------
math_game(){ local ok=0; for i in {1..5}; do a=$((RANDOM%30)); b=$((RANDOM%30)); read -t "$TIME" -p "$a+$b=" ans || return 1; [ "$ans" = "$((a+b))" ] && ok=$((ok+1)); done; [ $((ok*20)) -ge "$PASS" ]; }
typing_game(){ word="SECUREACCESS"; read -t "$TIME" -p "TYPE: $word > " in; [ "$in" = "$word" ]; }
memory_game(){ n=$((RANDOM%900+100)); echo "MEMORIZE: $n"; sleep 2; clear; read -t "$TIME" -p "ENTER: " in; [ "$in" = "$n" ]; }
play_game(){ echo "$1" >> "$REPLAY"; case $1 in math) math_game ;; typing) typing_game ;; memory) memory_game ;; esac || caught; }

# ------------------- Boss / Skill Tree -------------------
declare -A SKILL
SKILL=( ["fast_mini"]=0 ["extra_time"]=0 ["boss_reduce"]=0 )
upgrade_skills(){
clear
echo "💠 Skill Tree"
echo "1) Fast Mini-Game Response (level ${SKILL[fast_mini]})"
echo "2) Extra Time (level ${SKILL[extra_time]})"
echo "3) Boss Damage Reduction (level ${SKILL[boss_reduce]})"
echo "Enter number to upgrade (0 to exit):"
read -n1 sk
case $sk in 1) SKILL[fast_mini]=$((SKILL[fast_mini]+1)) ;; 2) SKILL[extra_time]=$((SKILL[extra_time]+1)) ;; 3) SKILL[boss_reduce]=$((SKILL[boss_reduce]+1)) ;; 0) return ;; esac
pause
}
caught(){ clear; beep; echo "🚨 TRACE COMPLETE — CAUGHT 🚨"; pause; exit; }
boss(){ cutscene "BOSS: $1"; PASS=$((PASS+10-SKILL[boss_reduce]*2)); TIME=$((TIME-1+SKILL[extra_time])); for g in math typing memory; do play_game "$g"; done; award "Defeated $1"; }

# ------------------- Open World / Maps -------------------
maps=("USA Datacenter" "India Cyber Grid" "Russia Defense Net" "China Satellite Hub" "EU Quantum Exchange")
open_world(){ while true; do clear; echo "🗺 Open World Maps"; select MAP in "${maps[@]}" "Exit Open World"; do break; done; [ "$MAP" = "Exit Open World" ] && break; cutscene "Entering $MAP"; mission; done; }

mission(){
PASS=$BASE_PASS; TIME=$BASE_TIME
for g in math typing memory; do echo "MAP: $MAP | GAME: $g | PASS: $PASS | TIME: $TIME"; pause; play_game "$g"; SCORE=$((SCORE+100)); done
boss "AI $MAP Boss"
SCORE=$((SCORE+200))
echo "$USER:$SCORE" >> "$HS"
award "Completed mission at $MAP"
}

cutscene(){ clear; echo "🎬 $1"; sleep 1; }

# ------------------- Dependency Management -------------------
check_dependency(){
    local cmd=$1
    local pkg=$2
    if ! command -v "$cmd" >/dev/null 2>&1; then
        read -p "⚠️ $cmd ($pkg) missing. Install? (y/N) " yn
        case $yn in
            [Yy]* ) sudo apt update && sudo apt install -y "$pkg";;
            * ) echo "Returning to menu..."; pause; return 1;;
        esac
    fi
    return 0
}

check_and_install_combo(){
    local cmds=($1)
    local missing=()
    for cmd in "${cmds[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing+=("$cmd")
        fi
    done
    [ ${#missing[@]} -eq 0 ] && return 0
    read -p "⚠️ Missing dependencies: ${missing[*]}. Install all? (y/N) " yn
    case $yn in
        [Yy]* )
            for pkg in "${missing[@]}"; do
                echo "Installing $pkg..."
                sudo apt update && sudo apt install -y "$pkg"
            done
            ;;
        * )
            echo "Returning to menu..."
            pause
            return 1
            ;;
    esac
    return 0
}

# ------------------- Multiplayer -------------------
host_game(){ check_dependency nc netcat || return; read -p "Host port: " PORT; echo "Hosting lobby on port $PORT..."; nc -l -p "$PORT" > /dev/null &; open_world; echo "$USER:$SCORE" | nc -q 1 localhost "$PORT"; }
join_game(){ check_dependency nc netcat || return; read -p "Host IP: " IP; read -p "Port: " PORT; open_world; echo "$USER:$SCORE" | nc -q 1 "$IP" "$PORT"; }
spectator(){ check_dependency nc netcat || return; read -p "Lobby port: " PORT; echo "👀 Spectating..."; nc -l -p "$PORT"; }

# ------------------- Fun Commands -------------------
fun_commands(){
    clear
    echo "💻 Fun Commands Menu"
    echo "1) fortune | cowsay | lolcat"
    echo "2) lolcat rainbow"
    echo "3) genact"
    echo "4) hollywood"
    echo "5) cmatrix"
    echo "6) sl"
    echo "7) Back"
    read -p "> " choice
    case $choice in
        1) check_and_install_combo "fortune cowsay lolcat" || return; fortune | cowsay | lolcat ;;
        2) check_and_install_combo "lolcat" || return; echo "Typing rainbow with lolcat..." ; echo "GOVHACK SIMULATOR" | lolcat ;;
        3) check_and_install_combo "genact" || return; genact ;;
        4) check_and_install_combo "hollywood" || return; hollywood ;;
        5) check_and_install_combo "cmatrix" || return; cmatrix ;;
        6) check_and_install_combo "sl" || return; sl ;;
        7) return ;;
        *) echo "Invalid"; pause ;;
    esac
    fun_commands
}

# ------------------- Scores / Achievements -------------------
view_scores(){ clear; echo "🏆 HIGHSCORES"; sort -t: -k2 -nr "$HS" | head -10; echo ""; echo "🏅 ACHIEVEMENTS"; cat "$ACH"; pause; }

# ------------------- Start Game -------------------
banner
read -p "OPERATOR NAME > " USER
[ -z "$USER" ] && USER="anonymous"

echo "Select Game Mode:"
echo "1) Easy 2) Normal 3) Hard"
read -p "> " gm
case $gm in
1) BASE_PASS=30; BASE_TIME=10 ;;
2) BASE_PASS=50; BASE_TIME=7 ;;
3) BASE_PASS=70; BASE_TIME=5 ;;
esac

SCORE=0

while true; do
clear
echo "1) Single Player"
echo "2) Multiplayer (Host)"
echo "3) Multiplayer (Join)"
echo "4) Spectator Mode"
echo "5) Skill Tree"
echo "6) Inventory"
echo "7) Fun Commands"
echo "8) Scores & Achievements"
echo "9) Exit"
read -p "> " c
case $c in
1) open_world ;;
2) host_game ;;
3) join_game ;;
4) spectator ;;
5) upgrade_skills ;;
6) view_inventory ;;
7) fun_commands ;;
8) view_scores ;;
9) echo "$USER:$SCORE" >> "$HS"; exit ;;
esac
done
