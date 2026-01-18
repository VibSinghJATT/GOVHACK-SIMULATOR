#!/bin/bash
# =========================================================
# GOVHACK SIMULATOR — macOS Edition
# Created by VibSingh
# GitHub: https://github.com/VibSinghJATT & https://github.com/Omgindia1234
# =========================================================

BASE="$HOME/.govhack_simulator"
mkdir -p "$BASE"
touch "$BASE/highscores.txt" "$BASE/achievements.txt" "$BASE/inventory.txt" "$BASE/replay.txt"

# ------------------- Helpers -------------------
pause() {
    read -p "Press Enter to continue..."
}

beep() {
    # macOS system beep
    echo -n $'\a'
}

banner() {
    clear
    echo "==============================="
    echo "  GOVHACK SIMULATOR — macOS"
    echo "  Created by VibSingh"
    echo "==============================="
    sleep 1
}

# ------------------- Dependency Installer -------------------
check_install() {
    # $@ = list of commands
    missing=()
    for cmd in "$@"; do
        if ! command -v $cmd &>/dev/null; then
            missing+=($cmd)
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        echo "Missing dependencies: ${missing[@]}"
        read -p "Install all missing via Homebrew? (y/N) " yn
        case $yn in
            [Yy]*)
                for pkg in "${missing[@]}"; do
                    brew install $pkg
                done
                ;;
            *)
                echo "Returning to menu..."
                return 1
                ;;
        esac
    fi
}

# ------------------- Inventory & Achievements -------------------
award() {
    # $1 = achievement
    if ! grep -qx "$1" "$BASE/achievements.txt"; then
        echo "$1" >> "$BASE/achievements.txt"
    fi
}

add_item() {
    # $1 = item
    echo "$1" >> "$BASE/inventory.txt"
}

view_inventory() {
    clear
    echo "📦 Inventory:"
    cat "$BASE/inventory.txt"
    pause
}

# ------------------- Mini-Games -------------------
math_game() {
    local ok=0
    for i in {1..5}; do
        a=$((RANDOM % 30))
        b=$((RANDOM % 30))
        read -p "$a + $b = " ans
        if [ "$ans" -eq $((a+b)) ]; then
            ok=$((ok+1))
        fi
    done
    [ $ok -ge 3 ] || caught
}

typing_game() {
    word="SECUREACCESS"
    read -p "TYPE: $word > " input
    [ "$input" == "$word" ] || caught
}

memory_game() {
    n=$((RANDOM % 900 + 100))
    echo "MEMORIZE: $n"
    sleep 2
    clear
    read -p "ENTER: " input
    [ "$input" == "$n" ] || caught
}

play_game() {
    case $1 in
        math) math_game ;;
        typing) typing_game ;;
        memory) memory_game ;;
    esac
    echo "$1" >> "$BASE/replay.txt"
}

# ------------------- Boss -------------------
boss() {
    echo "🎬 BOSS: $1"
    sleep 1
    play_game math
    play_game typing
    play_game memory
    award "Defeated $1"
}

# ------------------- Open World -------------------
maps=("USA Datacenter" "India Cyber Grid" "Russia Defense Net" "China Satellite Hub" "EU Quantum Exchange")

open_world() {
    while true; do
        clear
        echo "🗺 Open World Maps:"
        for i in "${!maps[@]}"; do
            echo "$((i+1))) ${maps[$i]}"
        done
        echo "$(( ${#maps[@]} + 1 ))) Back"
        read -p "Select Map: " choice
        if [ "$choice" -eq $(( ${#maps[@]} + 1 )) ]; then break; fi
        map="${maps[$((choice-1))]}"
        cutscene "Entering $map"
        mission "$map"
    done
}

mission() {
    map="$1"
    play_game math
    play_game typing
    play_game memory
    boss "AI $map Boss"
    echo "$USER:1000" >> "$BASE/highscores.txt"
    award "Completed mission at $map"
}

cutscene() {
    echo "🎬 $1"
    sleep 1
}

caught() {
    clear
    beep
    echo "🚨 TRACE COMPLETE — CAUGHT 🚨"
    pause
    exit
}

# ------------------- Fun Commands -------------------
fun_commands() {
    clear
    echo "💻 Fun Commands Menu"
    echo "1) Rainbow Text"
    echo "2) Matrix Effect"
    echo "3) Back"
    read -p "> " choice
    case $choice in
        1)
            check_install lolcat || return
            echo "GOVHACK SIMULATOR" | lolcat
            pause
            ;;
        2)
            check_install cmatrix || return
            cmatrix
            ;;
        3) return ;;
    esac
}

# ------------------- Scores -------------------
view_scores() {
    clear
    echo "🏆 Highscores:"
    cat "$BASE/highscores.txt"
    echo
    echo "🏅 Achievements:"
    cat "$BASE/achievements.txt"
    pause
}

# ------------------- Skill Tree -------------------
fast_mini=0
extra_time=0
boss_reduce=0

upgrade_skills() {
    clear
    echo "💠 Skill Tree"
    echo "1) Fast Mini-Game Response (level $fast_mini)"
    echo "2) Extra Time (level $extra_time)"
    echo "3) Boss Damage Reduction (level $boss_reduce)"
    echo "0) Back"
    read -p "Enter number to upgrade: " choice
    case $choice in
        1) fast_mini=$((fast_mini+1)) ;;
        2) extra_time=$((extra_time+1)) ;;
        3) boss_reduce=$((boss_reduce+1)) ;;
        0) return ;;
    esac
    pause
    upgrade_skills
}

# ------------------- Single Player -------------------
single_player() {
    open_world
}

# ------------------- Main Menu -------------------
banner
read -p "OPERATOR NAME > " USER
[ -z "$USER" ] && USER="anonymous"

while true; do
    clear
    echo "1) Single Player"
    echo "2) Skill Tree"
    echo "3) Inventory"
    echo "4) Fun Commands"
    echo "5) Scores & Achievements"
    echo "6) Exit"
    read -p "> " choice
    case $choice in
        1) single_player ;;
        2) upgrade_skills ;;
        3) view_inventory ;;
        4) fun_commands ;;
        5) view_scores ;;
        6) echo "$USER:1000" >> "$BASE/highscores.txt"; exit ;;
    esac
done