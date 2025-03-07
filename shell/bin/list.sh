#!/bin/bash

# Color definitions
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

services=("track" "worker" "server-unit")

echo -e "${BOLD}${CYAN}∘── Systemd Daemon Status ──∘${RESET}"
for service in "${services[@]}"; do
  status=$(systemctl is-active "$service" 2>/dev/null)
  loaded=$(systemctl is-enabled "$service" 2>/dev/null)

  if [[ $status == "active" ]]; then
    uptime=$(systemctl show -p ActiveEnterTimestamp "$service" | cut -d'=' -f2)
    pid=$(systemctl show -p MainPID "$service" | cut -d'=' -f2)
    echo -e "  ├─${GREEN}◉${RESET} ${BOLD}$service${RESET} → ${GREEN}Running${RESET}"
    echo -e "  │   ├─ ${CYAN}Uptime:${RESET} $uptime"
    echo -e "  │   └─ ${CYAN}PID:${RESET} $pid"
  elif [[ $loaded == "enabled" ]]; then
    echo -e "  ├─${YELLOW}○${RESET} ${BOLD}$service${RESET} → ${YELLOW}Loaded but Not Running${RESET}"
  else
    echo -e "  ├─${RED}⊙${RESET} ${BOLD}$service${RESET} → ${RED}Not Loaded${RESET}"
  fi
done
