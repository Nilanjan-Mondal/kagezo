#!/bin/bash
# Utility function for kagezoShell (Linux only)
# Future support for macOS will be added.
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

[[ "$(uname -s)" != "Linux" ]] && echo "Invalid platform detected" && exit 1

printc() { printf "%b%s%b\n" "$1" "$2" "$RESET"; }

declare -A services=(
  ["tracker"]="track"
  ["worker"]="worker"
  ["server"]="server-unit"
)

stop_service() {
  local service_name=$1
  local systemd_unit=${services[$service_name]}

  if systemctl is-active --quiet "$systemd_unit"; then
    sudo systemctl stop "$systemd_unit"
    sudo systemctl disable "$systemd_unit"
  else
    echo "No $service_name daemon instance running"
  fi
}

if [[ "$1" == "all" ]]; then
  for svc in "${!services[@]}"; do stop_service "$svc"; done
elif [[ -n "${services[$1]}" ]]; then
  stop_service "$1"
else
  printc ""
  printc ""
  printc "$GREEN" "     USAGE:  "
  printc "$GREEN" "     ◉  Check Daemon Status                         "
  printc "$YELLOW" "        └─○ list daemon                            "
  printc "$YELLOW" "            → Show status of all daemons              "
  printc ""
  printc ""

  exit 0
fi
./bin/list.sh daemon
