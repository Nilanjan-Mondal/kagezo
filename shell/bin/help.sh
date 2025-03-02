#!/bin/bash

# ANSI color codes
RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
BLUE="\033[34m"
MAGENTA="\033[35m"

echo -e "   ${BOLD}${BLUE}KagezoShell - Command Help${RESET}"
echo -e "   ${CYAN}───────────────────────────────────────────────────────${RESET}"
echo -e "   ${BOLD}Available Commands:${RESET}"
echo -e "   ${YELLOW}  help                 ${RESET}- Show this help menu"
echo -e "   ${GREEN}  list daemon          ${RESET}- List available daemons"
echo -e "   ${GREEN}  stop autobak         ${RESET}- Start auto backup daemon"
echo -e "   ${GREEN}  start autobak        ${RESET}- Stop auto backup daemon"
echo -e "   ${GREEN}  update tracker       ${RESET}- Update tracker list"
echo -e "   ${GREEN}  update cloudinary    ${RESET}- Update cloudinary credentials"
echo -e "   ${MAGENTA}  exit                 ${RESET}- Exit the shell"
echo -e "   ${CYAN}───────────────────────────────────────────────────────${RESET}"
echo -e "   ${BOLD}${YELLOW}Usage:${RESET} Type any command and press Enter."
echo -e "   ${CYAN}───────────────────────────────────────────────────────${RESET}"

