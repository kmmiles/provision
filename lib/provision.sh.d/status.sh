#!/bin/bash
# slackware style OK/FAIL status logs

__STATUS_MSG=
export __STATUS_MSG

################################################################################
# Print and save the status message
# Globals:
#   STATUS_MSG
# Arguments:
#   The message
# Oututs:
#   The message
################################################################################
status_msg() {
  STATUS_MSG="$1"
  printf '%s' "$STATUS_MSG"
}

################################################################################
# Prints green [OK] after the status message
# Arguments:
#   None
# Outputs:
#   See description
################################################################################
status_ok() {
  local len
  len=$(status_msglen)
  printf "%${len}s\\n" "[${TEXT_BOLD}${TEXT_GREEN} OK ${TEXT_NORMAL}]"
}

################################################################################
# Prints red [FAIL] after the status message
# Arguments:
#   None
# Outputs:
#   See description
################################################################################
status_fail() {
  local len
  len=$(status_msglen)
  printf "%${len}s\\n" "[${TEXT_BOLD}${TEXT_RED}FAIL${TEXT_NORMAL}]"

  if [[ -n "$__LOGFILE" ]]; then
    2>&1 putsr "Check logfile for details: $(relpath "$__LOGFILE")"
  fi
}

################################################################################
# Used for justifying the OK/FAIL text after each status message
# Globals:
#   STATUS_MSG
# Arguments:
#   None
# Outputs:
#   console width minus the current status message
################################################################################
status_msglen() {
  local msglen="${#STATUS_MSG}"
  local columns=
  columns=$(tput cols)
  echo "$((columns-msglen))"
}
