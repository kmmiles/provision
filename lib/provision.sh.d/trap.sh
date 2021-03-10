#!/bin/bash

################################################################################
# Function to call when trapping ERR
# Arguments:
#   None
# Returns:
#   Return code of source error
################################################################################
handle_trap_err() {
  local s=$?
  log_err "$0:$LINENO returned $s (cmd=\`$BASH_COMMAND\`)"
  exit $s
}
