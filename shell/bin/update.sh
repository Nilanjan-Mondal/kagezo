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
usage() {
  echo "Usage: update [track|ignore|cloudinary] [add|remove|update] [value]"
  echo "Examples:"
  echo "  update.sh track add /path/to/directory"
  echo "  update.sh ignore remove .jpeg"
  echo "  update.sh cloudinary update API_KEY 123456"
  exit 1
}

update_list() {
  local file=$1 action=$2 value=$3
  [[ ! -f $file ]] && touch "$file"

  case $action in
  add) grep -qxF "$value" "$file" || echo "$value" >>"$file" ;;
  remove) sed -i "\|^$value\$|d" "$file" ;;
  *) usage ;;
  esac
}

update_cloudinary() {
  local key=$1 value=$2
  [[ ! -f $ENV_FILE ]] && touch "$ENV_FILE"

  grep -q "^$key=" "$ENV_FILE" && sed -i "s|^$key=.*|$key=$value|" "$ENV_FILE" || echo "$key=$value" >>"$ENV_FILE"
}

case "$1" in
track | ignore)
  [[ -z $3 ]] && usage
  update_list "${!1^^}LIST" "$2" "$3"
  ;;
cloudinary)
  [[ $2 != "update" || -z $3 || -z $4 ]] && usage
  update_cloudinary "$3" "$4"
  ;;
*) usage ;;
esac

echo "[✔] Update successful!"
