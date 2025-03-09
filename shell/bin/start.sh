#!/bin/bash
# Utility function for kagezoShell (Linux only)
# Future support for macOS will be added.

[[ "$(uname -s)" != "Linux" ]] && echo "Invalid platform detected" && exit 1

printc() { printf "%b%s%b\n" "$1" "$2" "$RESET"; }

declare -A services=(
  ["tracker"]="track"
  ["worker"]="worker"
  ["server"]="server-unit"
)

start_service() {
  local service_name=$1
  local systemd_unit=${services[$service_name]}

  if systemctl is-active --quiet "$systemd_unit"; then
    echo "[+] $service_name is already running"
  else
    sudo systemctl enable "$systemd_unit"
    sudo systemctl start "$systemd_unit"
  fi
}

if [[ "$1" == "all" ]]; then
  for svc in "${!services[@]}"; do start_service "$svc"; done
elif [[ -n "${services[$1]}" ]]; then
  start_service "$1"
else
  printc ""
  printc ""
  printc "$GREEN" "  USAGE:  "
  printc "$GREEN" "  ◉  Start Daemons                               "
  printc "$YELLOW" "     └─○ start [tracker|worker|server|all]  "
  printc "$YELLOW" "         → Start specific/all daemons              "
  printc ""
  printc ""
  exit 0
fi

./bin/list.sh
