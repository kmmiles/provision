#!/usr/bin/env bash

################################################################################
# Just some common stuff for our scripts.
################################################################################

################################################################################
# global vars
################################################################################

TEXT_BOLD=$(tput bold)
TEXT_RED=$(tput setaf 1)
TEXT_GREEN=$(tput setaf 2)
TEXT_YELLOW=$(tput setaf 3)
TEXT_BLUE=$(tput setaf 4)
TEXT_NORMAL=$(tput sgr0)
STATUS_MSG=
LOGFILE=
DOWNLOADS="$HOME/Downloads"

################################################################################
# set options and expose magic variables for scripts sourcing this profile
# 
# __file  = absolute path of script
# __dir   = absolute path of directory containing script
# __root  = absolute path of parent directory containing script
################################################################################

if [[ -n "${BASH_SOURCE[1]:-}" ]]; then
  # sourced from script
  set -o errexit
  set -o pipefail
  set -o nounset

  __dir="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
  __file="${__dir}/$(basename "${BASH_SOURCE[1]}")"
  __root="$(cd "$(dirname "${__dir}")" && pwd)"
else
  # sourced from shell
  __dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  __file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
  __root="${__dir}"
fi

export __dir __file __root


################################################################################
# Some simple `is_x` exports.
################################################################################

is_ubuntu=$(grep -q "ID=ubuntu" /etc/os-release && echo true || echo false)
is_debian=$(grep -q "ID=debian" /etc/os-release && echo true || echo false)
is_wsl=$(command -v "wslpath" > /dev/null 2>&1 && echo true || echo false)

export is_ubuntu is_debian is_wsl

################################################################################
# Colored print commands
################################################################################

msg()         { printf "%s\n" "${1}" ; }
red_msg()     { printf "%s\n" "${TEXT_BOLD}${TEXT_RED}${1}${TEXT_NORMAL}" ; }
green_msg()   { printf "%s\n" "${TEXT_BOLD}${TEXT_GREEN}${1}${TEXT_NORMAL}" ; }
yellow_msg()  { printf "%s\n" "${TEXT_BOLD}${TEXT_YELLOW}${1}${TEXT_NORMAL}" ; }
blue_msg()    { printf "%s\n" "${TEXT_BOLD}${TEXT_BLUE}${1}${TEXT_NORMAL}" ; }

################################################################################
# sets log* functions to write to a logfile instead of stdout/stderr
################################################################################

enable_logfile() {
  local logrel

  logrel="logs/$(basename "$0").log"
  LOGFILE="${__root}/$logrel"

  mkdir -p "${__root}/logs"
  rm -f "$LOGFILE"
  touch "$LOGFILE"
}

################################################################################
# Generic log commands. Writes non-colored to $LOGFILE if set, else stdout.
################################################################################

log_msg() {
  if [[ "$LOGFILE" != "" ]]; then
    msg "[$(basename "$0")] ${1}" >> "$LOGFILE"
  else
    msg "[$(basename "$0")] ${1}"
  fi
}

log_err() {
  if [[ "$LOGFILE" != "" ]]; then
    msg "[$(basename "$0")] ${1}" >> "$LOGFILE"
  else
    >&2 red_msg "[$(basename "$0")] ${1}"
  fi
}

log_warn() {
  if [[ "$LOGFILE" != "" ]]; then
    msg "[$(basename "$0")] ${1}" >> "$LOGFILE"
  else
    >&2 yellow_msg "[$(basename "$0")] ${1}"
  fi
}

log_info() {
  if [[ "$LOGFILE" != "" ]]; then
    msg "[$(basename "$0")] ${1}" >> "$LOGFILE"
  else
    >&2 blue_msg "[$(basename "$0")] ${1}"
  fi
}

################################################################################
# Slackware-esquee OK/FAIL messages
################################################################################

status_msg() {
  STATUS_MSG="$1"
  printf '%s' "$STATUS_MSG"
}

status_msglen() {
  local msglen="${#STATUS_MSG}"
  local columns=
  columns=$(tput cols)
  echo "$((columns-msglen))"
}

status_ok() {
  local len
  len=$(status_msglen)
  printf "%${len}s\\n" "[${TEXT_BOLD}${TEXT_GREEN} OK ${TEXT_NORMAL}]"
}

status_fail() {
  local len
  len=$(status_msglen)
  printf "%${len}s\\n" "[${TEXT_BOLD}${TEXT_RED}FAIL${TEXT_NORMAL}]"
}

################################################################################
# require_ functions to be placed at top of scripts
################################################################################

require_non_root() {
  if [ "$(id -u)" == "0" ]; then
    redmsg "ERROR: Do not run this script as root."
    return 1
  fi
}

require_root() {
  if [ "$(id -u)" != "0" ]; then
    redmsg "ERROR: please run as normal user w/ sudo"
    return 1
  fi

  if [ -z "$SUDO_USER" ]; then
    redmsg "ERROR: please run as normal user w/ sudo"
    return 1
  fi
}

require_wsl() {
  if ! $is_wsl; then
    redmsg "ERROR: This script requires WSL2."
    return 1
  fi
}

################################################################################
# chkpath: verify all bins passed are in $PATH
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
# chkpkg: verify all packages passed are installed
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
# dl: Downloads url passed and prints the local path when succesful
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

################################################################################
# "main"
################################################################################
if $is_wsl; then
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

if [[ "${DEBUG:-}" ]]; then
  echo "*** Debug mode enabled ***"
  set -o xtrace
else
  set +o xtrace
fi
