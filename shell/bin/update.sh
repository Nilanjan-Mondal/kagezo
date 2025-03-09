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

case "$COMMAND" in
cloudinary)
  case "$ACTION" in
  name) VAR="CLOUDINARY_CLOUD_NAME" ;;
  key) VAR="CLOUDINARY_API_KEY" ;;
  secret) VAR="CLOUDINARY_API_SECRET" ;;
  *) printc "$RED" "✘ Error: Invalid cloudinary action." && exit 1 ;;
  esac
  sed -i "s/^$VAR *= *['\"].*['\"]/$VAR = '$VALUE'/" "$ENV_FILE"
  printc "$GREEN" "✔ $VAR updated successfully."
  ;;

tracker)
  case "$ACTION" in
  include)
    VALUE=$(basename "$VALUE")
    MATCHES=($(find "$USER_HOME" -type d -name "$VALUE" 2>/dev/null | awk '{ print length, $0 }' | sort -n | cut -d' ' -f2-))
    [ ${#MATCHES[@]} -eq 0 ] && printc "$RED" "✘ Error: No directories found for '$VALUE'." && exit 1
    if [ ${#MATCHES[@]} -eq 1 ]; then
      grep -iqxF "${MATCHES[0]}" "$TRACKER_FILE" || echo "${MATCHES[0]}" >>"$TRACKER_FILE"
      printc "$GREEN" "✔ Tracker updated: Included '${MATCHES[0]}'"
    else
      printc "$BLUE" "🔍 Multiple matches for '$VALUE':"
      for i in "${!MATCHES[@]}"; do printc "$YELLOW" "  ├─ ◉ $((i + 1)). ${MATCHES[$i]}"; done
      printc "$YELLOW" "  ├─ ◉ $((i + 2)). Add all"
      read -p "  └─ ➜ Choose: " choice
      if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice <= ${#MATCHES[@]})); then
        grep -iqxF "${MATCHES[$((choice - 1))]}" "$TRACKER_FILE" || echo "${MATCHES[$((choice - 1))]}" >>"$TRACKER_FILE"
        printc "$GREEN" "✔ Tracker updated: Included '${MATCHES[$((choice - 1))]}'"
      elif [ "$choice" -eq $((${#MATCHES[@]} + 1)) ]; then
        for dir in "${MATCHES[@]}"; do grep -iqxF "$dir" "$TRACKER_FILE" || echo "$dir" >>"$TRACKER_FILE"; done
        printc "$GREEN" "✔ Tracker updated: All directories added."
      else
        printc "$RED" "✘ Invalid choice. No changes made." && exit 1
      fi
    fi
    ;;

  exclude)
    MATCHES=($(grep "/$(basename "$VALUE")$" "$TRACKER_FILE"))
    [ ${#MATCHES[@]} -eq 0 ] && printc "$RED" "✘ Error: No match for '$VALUE' in tracker." && exit 1
    if [ ${#MATCHES[@]} -eq 1 ]; then
      sed -i "\|^${MATCHES[0]}$|d" "$TRACKER_FILE"
      printc "$GREEN" "✔ Tracker updated: Excluded '${MATCHES[0]}'"
    else
      printc "$BLUE" "Multiple matches for '$VALUE':"
      for i in "${!MATCHES[@]}"; do printc "$YELLOW" "  ├─ ◉ $((i + 1)). ${MATCHES[$i]}"; done
      printc "$YELLOW" "  ├─ ◉ $((i + 2)). Delete all"
      read -p "  └─ ➜ Choose: " choice
      if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice <= ${#MATCHES[@]})); then
        sed -i "\|^${MATCHES[$((choice - 1))]}$|d" "$TRACKER_FILE"
        printc "$GREEN" "✔ Tracker updated: Excluded '${MATCHES[$((choice - 1))]}'"
      elif [ "$choice" -eq $((${#MATCHES[@]} + 1)) ]; then
        for dir in "${MATCHES[@]}"; do sed -i "\|^$dir$|d" "$TRACKER_FILE"; done
        printc "$GREEN" "✔ Tracker updated: All removed."
      else
        printc "$RED" "✘ Invalid choice. No changes made." && exit 1
      fi
    fi
    ;;
  *)
    printc "$RED" "✘ Error: Invalid tracker action." && exit 1
    ;;
  esac
  ;;

esac
echo "[✔] Update successful!"
