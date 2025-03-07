#/bin/bash
# This file is a utility function for kagezoShell
# right now it only supports Linux
# will add support for MacOS in the future
#
if [[ "$(uname -s)" == "Linux" ]]; then

  if [[ "$1" == "tracker" ]]; then
    if systemctl is-active --quiet track; then
      sudo systemctl stop track
      sudo systemctl disable track
      sudo systemctl status track

    else
      echo "No tracker daemon instance running"
      systemctl status track
    fi

  elif [[ "$1" == "worker" ]]; then
    if systemctl is-active --quiet worker; then
      sudo systemctl stop worker
      sudo systemctl disable worker
      sudo systemctl status worker
    else
      echo "No worker daemon instance running"
      systemctl status worker
    fi

  elif [[ "$1" == "server" ]]; then
    if systemctl is-active --quiet server-unit; then
      sudo systemctl stop server-unit
      sudo systemctl disable server-unit
      sudo systemctl status server-unit
    else
      echo "No server daemon instance running"
      systemctl status server-unit

    fi

  else
    echo "Usage: stop [tracker|worker|server]"
    exit 0
  fi
else
  echo "invalid platform detected"
  exit 1
fi
