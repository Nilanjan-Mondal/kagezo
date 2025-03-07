#/bin/bash
# This file is a utility function for kagezoShell
# right now it only supports Linux
# will add support for MacOS in the future
#
if [[ "$(uname -s)" == "Linux" ]]; then

  if [[ "$1" == "tracker" ]]; then
    if systemctl is-active --quiet track; then
      echo "Tracker is already running"
      systemctl status track
    else
      sudo systemctl enable track
      sudo systemctl start track
      sudo systemctl status track
    fi
  elif [[ "$1" == "worker" ]]; then
    if systemctl is-active --quiet worker; then
      echo "Worker is already running"
      systemctl status worker
    else
      sudo systemctl enable worker
      sudo systemctl start worker
      sudo systemctl status worker
    fi
  elif [[ "$1" == "server" ]]; then
    if systemctl is-active --quiet server-unit; then
      echo "Server is already running"
      systemctl status server-unit
    else
      sudo systemctl enable server-unit
      sudo systemctl start server-unit
      sudo systemctl status server-unit
    fi

  else
    echo "Usage: start [tracker|worker|server]"
    exit 0
  fi
else
  echo "invalid platform detected"
  exit 1
fi
