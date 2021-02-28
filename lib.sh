#!/bin/bash

# library of common things used by scripts 

################################################################################
# Functions to print a message in various colors
#
# Globals:
#   None
# Arguments:
#   The message
################################################################################
msg()         { printf "%s\n" "${1}" ; }
red_msg()     { printf "%s\n" "${TEXT_BOLD}${TEXT_RED}${1}${TEXT_NORMAL}" ; }
green_msg()   { printf "%s\n" "${TEXT_BOLD}${TEXT_GREEN}${1}${TEXT_NORMAL}" ; }
yellow_msg()  { printf "%s\n" "${TEXT_BOLD}${TEXT_YELLOW}${1}${TEXT_NORMAL}" ; }
blue_msg()    { printf "%s\n" "${TEXT_BOLD}${TEXT_BLUE}${1}${TEXT_NORMAL}" ; }

################################################################################
# Print plain message to stdout (or __LOGFILE)
# Globals:
#   __LOGFILE
# Arguments:
#   The message
################################################################################
log_msg() {
  if [[ "$__LOGFILE" != "" ]]; then
    msg "$(log_get_title)${1}" >> "$__LOGFILE"
  else
    msg "$(log_get_title)${1}"
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
    msg "$(log_get_title)${1}" >> "$__LOGFILE"
  else
    >&2 red_msg "$(log_get_title)${1}"
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
    msg "$(log_get_title)${1}" >> "$__LOGFILE"
  else
    >&2 yellow_msg "$(log_get_title)${1}"
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
    msg "$(log_get_title)${1}" >> "$__LOGFILE"
  else
    >&2 blue_msg "$(log_get_title)${1}"
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
log_get_title() {
  if [[ "$__SOURCE" == "script" ]];  then
    echo "[$(basename "$0")] "
  else
    echo ""
  fi
}

################################################################################
# Print and save a status message for a slackware-esquee OK/FAIL line.
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

################################################################################
# Require a script to be run as a non-root user
# Outputs:
#   Error message to stderr, if applicable
# Returns:
#   1 on error
################################################################################
require_non_root() {
  if [[ "$(id -u)" == "0" ]]; then
    redmsg "ERROR: Do not run this script as root."
    return 1
  fi
}

################################################################################
# Require a script to be run as the root user
# Globals:
#   SUDO_USER
# Outputs:
#   Error message to stderr, if applicable
# Returns:
#   1 on error
################################################################################
require_root() {
  if [[ "$(id -u)" != "0" ]]; then
    redmsg "ERROR: please run as normal user w/ sudo"
    return 1
  fi

  if [[ -z "$SUDO_USER" ]]; then
    redmsg "ERROR: please run as normal user w/ sudo"
    return 1
  fi
}

################################################################################
# Require WSL2 to run a script
# Globals:
#   IS_WSL 
# Outputs:
#   Error message to stderr, if applicable
# Returns:
#   1 on error
################################################################################
require_wsl() {
  if ! $IS_WSL; then
    redmsg "ERROR: This script requires WSL2."
    return 1
  fi
}

################################################################################
# Check for programs in PATH
# Arguments:
#   Variable number of program names
# Returns:
#   1 if any programs are not in PATH
################################################################################
chkpath() {
  # no programs specified
  if [[ $# -eq 0 ]]; then
    return 1
  fi

  for prog in "$@"; do
    command -v "$prog" > /dev/null 2>&1 || return 1
  done
}

################################################################################
# Check for installed packages
# Arguments:
#   Variable number of package names
# Returns:
#   1 if packages are not installed
################################################################################
chkpkg() {
  # no packages specified
  if [[ $# -eq 0 ]]; then
    return 1
  fi

  for pkg in "$@"; do
    dpkg -V "$pkg" > /dev/null 2>&1 || return 1
  done
}

################################################################################
# Downloads url
# Arguments:
#   The URL
# Outputs:
#   Absolute path of downloaded file on success
# Returns:
#   1 on error
################################################################################
dl() {
  local url filepath filename

  url="$1"
  if [[ -z "$url" ]]; then
    return 1
  fi

  filename=$(basename "$url")
  filepath="$DOWNLOADS/$filename"

  # destination directory must exist
  if [[ ! -d "$DOWNLOADS" ]]; then
    log_err "Directory does not exist \"$DOWNLOADS\"."
    return 1 
  fi

  # download file
  if [[ ! -f "$filepath" ]]; then
    log_info "Downloading \"$url\" to \"$DOWNLOADS\"..."
    if ! curl -sfL -o "$filepath" "$url" > /dev/null; then
      log_err "Failed to download \"$url\"."
      return 1
    fi
  fi

  # print path of downloaded file
  echo "$filepath"
}

################################################################################
# get the windows username (only applies to WSL2)
# Arguments:
#   Letter of primary windows drive (e.g. "c")
# Outputs:
#   username
################################################################################
get_win_user() {
  local win_drive="$1"
  declare -a invalid_users
  invalid_users=( Administrator Default DefaultAccount Guest Public WDAGUtilityAccount )
  find "/mnt/$win_drive/Users" -mindepth 1 -maxdepth 1 -type d |
    while read -r line; do
      user="$(basename "$line")"
      if [[ ${invalid_users[*]} =~ ${user} ]]; then
        continue
      fi
    
      echo "$user"
      break
    done
}

# basic text colors
TEXT_BOLD=$(tput bold)
TEXT_RED=$(tput setaf 1)
TEXT_GREEN=$(tput setaf 2)
TEXT_YELLOW=$(tput setaf 3)
TEXT_BLUE=$(tput setaf 4)
TEXT_NORMAL=$(tput sgr0)
export TEXT_BOLD TEXT_RED TEXT_GREEN TEXT_YELLOW TEXT_BLUE TEXT_NORMAL

# files downloaded with `dl()` are stored here
DOWNLOADS="$HOME/Downloads"
export DOWNLOADS

# message that is set/used by status_* functions
__STATUS_MSG=
export __STATUS_MSG

# log_* functions write to __LOGFILE if set (instead of stdout/err)
__LOGFILE=
export __LOGFILE

# determine and export:
#
#   __SOURCE: Who sourced this library? "script" or "shell".
#   __DIR: Directory of the script that sourced this library. 
#   __FILE: Filename of the script that sourced this library.
#   __ROOT: Parent directory of the script that sourced this library.
if [[ -n "${BASH_SOURCE[1]:-}" ]]; then
  __SOURCE="script"
  __DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
  __FILE="${__DIR}/$(basename "${BASH_SOURCE[1]}")"
  __ROOT="$(cd "$(dirname "${__DIR}")" && pwd)"
else
  __SOURCE="shell"
  __DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  __FILE="${__DIR}/$(basename "${BASH_SOURCE[0]}")"
  __ROOT="${__DIR}"
fi
export __DIR __FILE __ROOT __SOURCE

# determine some info about the platform
IS_UBUNTU=$(grep -q "ID=ubuntu" /etc/os-release && echo true || echo false)
IS_DEBIAN=$(grep -q "ID=debian" /etc/os-release && echo true || echo false)
IS_WSL=$(command -v "wslpath" > /dev/null 2>&1 && echo true || echo false)
export IS_UBUNTU IS_DEBIAN IS_WSL

if [[ "$__SOURCE" == "script" ]]; then
  set -o errexit
  set -o pipefail
  set -o nounset
fi


if [[ "${DEBUG:-}" ]]; then
  echo "*** Debug mode enabled ***"
  set -o xtrace
else
  set +o xtrace
fi

# TODO: main function
if $IS_WSL; then
  path="$HOME/winhome"

  if [[ ! -L "$path" || ! -d "$path" ]]; then
    echo "Creating winhome link in $HOME/winhome..."
    win_drive="$(basename "$(grep drvfs /proc/self/mounts | head -n 1 | cut -d' ' -f 2)")"
    win_user="$(get_win_user "$win_drive")"
    win_home="/mnt/$win_drive/Users/$win_user"
    if [ -d "$win_home" ]; then
      ln -vsf "$win_home" "$HOME/winhome"
    fi

    for d in Downloads Music; do
      if [[ ! -d "$HOME/$d" ]]; then
        ln -vsf "$win_home/$d" "$HOME/$d"
      fi
    done
  fi
fi

