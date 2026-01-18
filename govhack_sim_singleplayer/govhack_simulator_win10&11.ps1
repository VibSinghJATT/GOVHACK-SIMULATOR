# =========================================================
# GOVHACK SIMULATOR — Windows Edition
# Created by: VibSingh
# GitHub: https://github.com/VibSinghJATT & https://github.com/Omgindia1234
# PowerShell native version — no WSL required
# =========================================================

# ------------------- Setup Directories -------------------
$BASE = "$env:USERPROFILE\.govhack_simulator"
$MODS = "$BASE\mods"
$HS = "$BASE\highscores.txt"
$ACH = "$BASE\achievements.txt"
$SAVE = "$BASE\save.txt"
$INV = "$BASE\inventory.txt"
$REPLAY = "$BASE\replay.txt"

New-Item -ItemType Directory -Force -Path $BASE, $MODS | Out-Null
New-Item -ItemType File -Force -Path $HS, $ACH, $SAVE, $INV, $REPLAY | Out-Null

# ------------------- Helpers -------------------
function Pause { Write-Host "Press Enter..."; Read-Host | Out-Null }
function Beep { [console]::beep(800,200) }

# ------------------- Banner -------------------
function Banner {
    Clear-Host
    Write-Host "==============================="
    Write-Host "  GOVHACK SIMULATOR — Windows  "
    Write-Host "  Created by: VibSingh"
    Write-Host "  GitHub: https://github.com/VibSinghJATT & https://github.com/Omgindia1234"
    Write-Host "==============================="
    Start-Sleep -Seconds 1
}

# ------------------- Achievements & Inventory -------------------
function Award($text) {
    if (-not (Select-String -Path $ACH -Pattern "^$text$")) { Add-Content -Path $ACH -Value $text }
}
function Add-Item($item) { Add-Content -Path $INV -Value $item }
function View-Inventory {
    Clear-Host
    Write-Host "📦 Inventory:"
    Get-Content $INV
    Pause
}

# ------------------- Mini-Games -------------------
function MathGame {
    $ok=0
    for ($i=0; $i -lt 5; $i++) {
        $a = Get-Random -Minimum 0 -Maximum 30
        $b = Get-Random -Minimum 0 -Maximum 30
        $ans = Read-Host "$a + $b = "
        if ($ans -eq ($a+$b)) { $ok++ }
    }
    return $ok -ge 3
}

function TypingGame {
    $word = "SECUREACCESS"
    $input = Read-Host "TYPE: $word >"
    return $input -eq $word
}

function MemoryGame {
    $n = Get-Random -Minimum 100 -Maximum 999
    Write-Host "MEMORIZE: $n"
    Start-Sleep -Seconds 2
    Clear-Host
    $input = Read-Host "ENTER:"
    return $input -eq $n
}

function PlayGame($type) {
    switch ($type) {
        "math" { if (-not (MathGame)) { Caught } }
        "typing" { if (-not (TypingGame)) { Caught } }
        "memory" { if (-not (MemoryGame)) { Caught } }
    }
    Add-Content -Path $REPLAY -Value $type
}

# ------------------- Boss / Skills -------------------
$SKILL = @{ "fast_mini"=0; "extra_time"=0; "boss_reduce"=0 }

function UpgradeSkills {
    Clear-Host
    Write-Host "💠 Skill Tree"
    Write-Host "1) Fast Mini-Game Response (level $($SKILL.fast_mini))"
    Write-Host "2) Extra Time (level $($SKILL.extra_time))"
    Write-Host "3) Boss Damage Reduction (level $($SKILL.boss_reduce))"
    $choice = Read-Host "Enter number to upgrade (0 to exit)"
    switch ($choice) {
        "1" { $SKILL.fast_mini++ }
        "2" { $SKILL.extra_time++ }
        "3" { $SKILL.boss_reduce++ }
        "0" { return }
    }
    Pause
}

function Caught {
    Clear-Host
    Beep
    Write-Host "🚨 TRACE COMPLETE — CAUGHT 🚨"
    Pause
    Exit
}

function Boss($name) {
    Cutscene "BOSS: $name"
    foreach ($g in "math","typing","memory") { PlayGame $g }
    Award "Defeated $name"
}

# ------------------- Open World -------------------
$Maps = @("USA Datacenter","India Cyber Grid","Russia Defense Net","China Satellite Hub","EU Quantum Exchange")
function OpenWorld {
    while ($true) {
        Clear-Host
        Write-Host "🗺 Open World Maps"
        $Maps + "Exit Open World" | ForEach-Object { Write-Host "$($_)" }
        $MAP = Read-Host "Select Map"
        if ($MAP -eq "Exit Open World") { break }
        Cutscene "Entering $MAP"
        Mission $MAP
    }
}

function Mission($MAP) {
    foreach ($g in "math","typing","memory") {
        Write-Host "MAP: $MAP | GAME: $g"
        Pause
        PlayGame $g
    }
    Boss "AI $MAP Boss"
    Add-Content -Path $HS -Value "$USER:1000"
    Award "Completed mission at $MAP"
}

function Cutscene($text) {
    Clear-Host
    Write-Host "🎬 $text"
    Start-Sleep -Seconds 1
}

# ------------------- Fun Commands -------------------
function FunCommands {
    Clear-Host
    Write-Host "💻 Fun Commands Menu"
    Write-Host "1) Rainbow Text"
    Write-Host "2) Matrix Effect"
    Write-Host "3) Back"
    $choice = Read-Host "> "
    switch ($choice) {
        "1" {
            $text = "GOVHACK SIMULATOR"
            $colors = [System.Enum]::GetValues([System.ConsoleColor])
            for ($i=0; $i -lt $text.Length; $i++) {
                $color = $colors[Get-Random -Minimum 0 -Maximum $colors.Length]
                Write-Host $text[$i] -NoNewline -ForegroundColor $color
            }
            Write-Host ""
            Pause
        }
        "2" {
            for ($i=0; $i -lt 50; $i++) {
                $line = -join ((65..90) | Get-Random -Count 50 | ForEach-Object {[char]$_})
                Write-Host $line
                Start-Sleep -Milliseconds 50
            }
            Pause
        }
        "3" { return }
    }
    FunCommands
}

# ------------------- Scores -------------------
function ViewScores {
    Clear-Host
    Write-Host "🏆 HIGHSCORES"
    Get-Content $HS | Sort-Object -Descending | Select-Object -First 10
    Write-Host "🏅 ACHIEVEMENTS"
    Get-Content $ACH
    Pause
}

# ------------------- Start Game -------------------
Banner
$USER = Read-Host "OPERATOR NAME"
if ([string]::IsNullOrWhiteSpace($USER)) { $USER="anonymous" }

Write-Host "Select Game Mode:"
Write-Host "1) Easy 2) Normal 3) Hard"
$gm = Read-Host "> "
switch ($gm) {
    "1" { $BASE_PASS=30; $BASE_TIME=10 }
    "2" { $BASE_PASS=50; $BASE_TIME=7 }
    "3" { $BASE_PASS=70; $BASE_TIME=5 }
}

$SCORE=0

while ($true) {
    Clear-Host
    Write-Host "1) Single Player"
    Write-Host "2) Skill Tree"
    Write-Host "3) Inventory"
    Write-Host "4) Fun Commands"
    Write-Host "5) Scores & Achievements"
    Write-Host "6) Exit"
    $c = Read-Host "> "
    switch ($c) {
        "1" { OpenWorld }
        "2" { UpgradeSkills }
        "3" { View-Inventory }
        "4" { FunCommands }
        "5" { ViewScores }
        "6" { Add-Content -Path $HS -Value "$USER:$SCORE"; Exit }
    }
}
