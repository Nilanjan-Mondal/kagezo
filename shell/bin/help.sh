#!/bin/bash

# Colors for better readability
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
WHITE="\033[97m"
RESET="\033[0m"

# Function to print colored output
printc() { printf "%b%s%b\n" "$1" "$2" "$RESET"; }

# Header
printc "$CYAN" "╔═════════════════════════════════════════════════╗"
printc "$CYAN" "║            KagezoShell Utility Help             ║"
printc "$CYAN" "╠═════════════════════════════════════════════════╣"

# Start Daemons
printc "$GREEN" "║  ◉  Start Daemons                               ║"
printc "$YELLOW" "║     ├─○ ./start.sh [tracker|worker|server|all]  ║"
printc "$YELLOW" "║     └─○ Start specific/all daemons              ║"

# Stop Daemons
printc "$GREEN" "║  ◉  Stop Daemons                                ║"
printc "$YELLOW" "║     ├─○ ./stop.sh [tracker|worker|server|all]   ║"
printc "$YELLOW" "║     └─○ Stop specific/all daemons               ║"

# Check Daemon Status
printc "$GREEN" "║  ◉  Check Daemon Status                         ║"
printc "$YELLOW" "║     ├─○ ./status.sh                             ║"
printc "$YELLOW" "║     └─○ Show status of all daemons              ║"

# Update Tracklist & Ignorelist
printc "$GREEN" "║  ◉  Update Tracklist & Ignorelist               ║"
printc "$YELLOW" "║     ├─○ ./update.sh track add /path/to/dir      ║"
printc "$YELLOW" "║     │    → Add directory to tracklist.txt       ║"
printc "$YELLOW" "║     ├─○ ./update.sh track remove /path/to/dir   ║"
printc "$YELLOW" "║     │    → Remove directory from tracklist      ║"
printc "$YELLOW" "║     ├─○ ./update.sh ignore add .ext             ║"
printc "$YELLOW" "║     │    → Add extension to ignore.txt          ║"
printc "$YELLOW" "║     ├─○ ./update.sh ignore remove .ext          ║"
printc "$YELLOW" "║     │    → Remove extension from ignore.txt     ║"
printc "$YELLOW" "║     └─○ Update tracklist and ignorelist         ║"

# Update Cloudinary API Keys
printc "$GREEN" "║  ◉  Update Cloudinary API Keys                  ║"
printc "$YELLOW" "║     ├─○ ./update.sh cloudinary update API_KEY   ║"
printc "$YELLOW" "║     │    → Update Cloudinary API Key            ║"
printc "$YELLOW" "║     ├─○ ./update.sh cloudinary update API_SECRET║"
printc "$YELLOW" "║     │    → Update Cloudinary API Secret         ║"
printc "$YELLOW" "║     └─○ Manage Cloudinary credentials           ║"

# Footer
printc "$CYAN" "╚═════════════════════════════════════════════════╝"
