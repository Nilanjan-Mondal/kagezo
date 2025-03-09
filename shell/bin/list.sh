#!/bin/bash

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

services=("track" "worker" "server-unit")
printc() { printf "%b%s%b\n" "$1" "$2" "$RESET"; }
if [[ "$1" == "daemon" ]]; then
  printc "$CYAN" "                                                   "
  printc "$CYAN" "                                                   "
  printc "$CYAN" "╔═════════════════════════════════════════════════╗"
  printc "$CYAN" "║          ∘── Systemd Daemon Status ──∘          ║"
  printc "$CYAN" "╠═════════════════════════════════════════════════╣"
  printc "$CYAN" "║                                                 ║ "
  for service in "${services[@]}"; do
    status=$(systemctl is-active "$service" 2>/dev/null)
    loaded=$(systemctl is-enabled "$service" 2>/dev/null)

    if [[ $status == "active" ]]; then
      uptime=$(systemctl show -p ActiveEnterTimestamp "$service" | cut -d'=' -f2)
      pid=$(systemctl show -p MainPID "$service" | cut -d'=' -f2)
      printc "    ├─${GREEN}◉${RESET} ${BOLD}$service${RESET} → ${GREEN}" "Running"
      printc "    │   ├─ ${CYAN}Uptime:${RESET} " "$uptime"
      printc "    │   └─ ${CYAN}PID:${RESET} " "$pid"
    elif [[ $loaded == "enabled" ]]; then
      printc "    ├─${YELLOW}○${RESET} ${BOLD}$service${RESET} → ${YELLOW}" "Loaded but Not Running"
    else
      printc "    ├─${RED}⊙${RESET} ${BOLD}$service${RESET} → ${RED}" "Not Loaded"
    fi
  done
  printc "$CYAN" "║                                                 ║ "
  printc "$CYAN" "╚═════════════════════════════════════════════════╝"
  printc "$CYAN" "                                                   "
  printc "$CYAN" "                                                   "
else
  printc ""
  printc ""
  printc "$GREEN" "     USAGE:"
  printc "$GREEN" "     ◉  Check Daemon Status                         "
  printc "$YELLOW" "        └─○ list daemon                            "
  printc "$YELLOW" "            → Show status of all daemons              "
  printc ""
  printc ""
fi
