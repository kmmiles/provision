#!/usr/bin/env bash

# x11 for wsl2 
if command -v wslpath > /dev/null 2>&1; then
  DISPLAY=$(grep nameserver /etc/resolv.conf | awk '{print $2; exit;}'):0.0
  export DISPLAY
fi
