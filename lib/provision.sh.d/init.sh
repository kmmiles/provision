#!/bin/bash

################################################################################
# init function for scripts to run after sourcing this library
# Arguments:
#   None
# Returns:
#   1 on error
################################################################################
lib_init() {
  if [[ "$(id -u)" == "0" ]]; then
    2>&1 putsr "ERROR: Do not run this script as root."
    return 1
  fi
  handle_wsl2
}
