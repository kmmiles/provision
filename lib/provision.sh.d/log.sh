#!/bin/bash
# log message functions

__LOGFILE=
export __LOGFILE

################################################################################
# Print plain message to stdout (or __LOGFILE)
# Globals:
#   __LOGFILE
# Arguments:
#   The message
################################################################################
log_msg() {
  if [[ "$__LOGFILE" != "" ]]; then
    puts "$(log_get_title)${1}" >> "$__LOGFILE"
  else
    puts "$(log_get_title)${1}"
  fi
}

################################################################################
# Print red error message to stderr (or __LOGFILE)
# Globals:
#   __LOGFILE
# Arguments:
#   The message
################################################################################
log_err() {
  if [[ "$__LOGFILE" != "" ]]; then
    puts "$(log_get_title)${1}" >> "$__LOGFILE"
  else
    >&2 putsr "$(log_get_title)${1}"
  fi
}

################################################################################
# Print yellow warning message to stderr (or __LOGFILE)
# Globals:
#   __LOGFILE
# Arguments:
#   The message
################################################################################
log_warn() {
  if [[ "$__LOGFILE" != "" ]]; then
    puts "$(log_get_title)${1}" >> "$__LOGFILE"
  else
    >&2 putsy "$(log_get_title)${1}"
  fi
}

################################################################################
# Print blue info message to stderr (or __LOGFILE)
# Globals:
#   __LOGFILE
# Arguments:
#   The message
################################################################################
log_info() {
  if [[ "$__LOGFILE" != "" ]]; then
    puts "$(log_get_title)${1}" >> "$__LOGFILE"
  else
    >&2 putsb "$(log_get_title)${1}"
  fi
}

################################################################################
# Sets log* functions to write to a file instead of stdout/stderr
#
# Globals:
#   __LOGFILE
# Arguments:
#   None
################################################################################
log_use_file() {
  local logrel

  logrel="logs/$(basename "$0").log"
  __LOGFILE="${__ROOT}/$logrel"

  mkdir -p "${__ROOT}/logs"
  rm -f "$__LOGFILE"
  touch "$__LOGFILE"
}

################################################################################
# Print prefix string of log messages (program named wrapped in brackets).
# Globals:
#   SOURCE
# Arguments:
#   None
# Outputs:
#   Prefix string or empty if not a script    
################################################################################
log_get_title() { echo "[$(basename "$__FILE")] "; }

