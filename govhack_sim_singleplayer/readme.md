
```md
# GOVHACK SIMULATOR — Single Player Mode

This document explains how to run the **single-player offline version** of GOVHACK SIMULATOR on every supported operating system.

---

## 🐧 Linux

```bash
chmod +x govhack_sim_linux.sh
./govhack_sim_linux.sh
Save data location:

bash
Copy code
~/.govhack_simulator/
🍎 macOS
bash
Copy code
chmod +x govhack_sim_mac.sh
./govhack_sim_mac.sh
Optional tools (auto-prompted):

lolcat

cmatrix

Installed via Homebrew if missing.

🪟 Windows 10 / 11 (PowerShell)
Right-click file

Run with PowerShell

Or manually:

powershell
Copy code
powershell -ExecutionPolicy Bypass -File govhack_simulator_win10&11.ps1
Save data location:

shell
Copy code
%APPDATA%\GovHackSimulator\
🪟 Windows XP / Vista / 7
Double-click:

bat
Copy code
govhack_simulator_winXPto7.bat
No PowerShell required.
Works on very old PCs.

🐧 WSL (Windows Subsystem for Linux)
bash
Copy code
chmod +x govhack_sim_wsl.sh
./govhack_sim_wsl.sh
Uses Linux backend but optimized for WSL paths.

🎮 Gameplay Flow
Enter operator name

Choose Single Player

Select world map

Complete mini-games

Defeat AI bosses

Unlock achievements & skills

Fail a mission → TRACE COMPLETE (Game Over)

💾 Persistent Data
Inventory

Achievements

Highscores

Replay history

Stored locally per OS.

🛑 Notes
No internet required

No servers involved

No tracking

No telemetry

Pure offline gameplay.

🧩 Mods
Mod support is planned for future versions via:

Script extensions

Custom mission packs

Enjoy hacking responsibly 😎

yaml
Copy code

---
