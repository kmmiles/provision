#!/bin/bash

# determine some info about the platform
IS_UBUNTU=$(grep -q "ID=ubuntu" /etc/os-release && echo true || echo false)
IS_DEBIAN=$(grep -q "ID=debian" /etc/os-release && echo true || echo false)
IS_WSL=$(command -v "wslpath" > /dev/null 2>&1 && echo true || echo false)
if [[ "$(systemctl get-default)" == "graphical.target" ]]; then
  IS_GUI=true
else
  IS_GUI=false
fi
export IS_UBUNTU IS_DEBIAN IS_WSL IS_GUI
