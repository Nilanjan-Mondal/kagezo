#!/bin/bash

# Color codes
RESET="\e[0m"
GREEN="\e[32m"
RED="\e[31m"
BLUE="\e[34m"
YELLOW="\e[33m"
BOLD="\e[1m"

USER_HOME=$(eval echo ~$SUDO_USER)
TRACKER_FILE="$USER_HOME/.local/share/kagezo/track.txt"
IGNORE_FILE="$USER_HOME/.local/share/kagezo/ignore.txt"
ENV_FILE="/opt/kagezo/Server/.env"

printc() { printf "%b%s%b\n" "$1" "$2" "$RESET"; }

[ "$#" -lt 3 ] && echo "Usage: update [track|ignore|cloudinary] <value>"
echo "Examples:"
echo "  update tracker [include|exclude] <directory>"
echo "  update ignore [include|exclude] <.extension>"
echo "  update cloudinary update [name|key|secret] <value>"
echo ""
printc "$YELLOW" "[!] No need to give full path for tracker. It automatically searches your home directory"
printc "$YELLOW" "[!] In case of multiple directories found, you can choose which one to include or exclude"
exit 1 && exit 1

COMMAND=$1 ACTION=$2 VALUE=$3

# Elevate privileges
[ "$EUID" -ne 0 ] && exec sudo "$0" "$@"

echo "[✔] Update successful!"
