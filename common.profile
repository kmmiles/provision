################################################################################
# Just some common stuff for our scripts
################################################################################

TEXT_BOLD=$(tput bold)
TEXT_RED=$(tput setaf 1)
TEXT_GREEN=$(tput setaf 2)
TEXT_NORMAL=$(tput sgr0)
STATUS_MSG=
LOGFILE=
DOWNLOADS=

if [ ! -z "${BASH_SOURCE[1]:-}" ]; then
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

enable_logfile() {
  local logrel="logs/$(basename "$0").log"
  LOGFILE="${__root}/$logrel"

  mkdir -p "${__root}/logs"
  rm -f "$LOGFILE"
  touch "$LOGFILE"

  #echo "Logging to $logrel"
}


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

logmsg() {
  local msg prog
  msg="$1"
  prog=$(basename "$0")

  if [ "$LOGFILE" != "" ]; then
    printf "%s\n" "[$prog] ${msg}" >> "$LOGFILE"
  else
    printf "%s\n" "[$prog] ${msg}"
  fi
}

redmsg() {
  local msg
  msg="$1"
  printf "%s\n" "${TEXT_BOLD}${TEXT_RED}${msg}${TEXT_NORMAL}"
}

greenmsg() {
  local msg
  msg="$1"
  printf "%s\n" "${TEXT_BOLD}${TEXT_GREEN}${msg}${TEXT_NORMAL}"
}

require_non_root() {
  if [ "$(id -u)" == "0" ]; then
    redmsg "ERROR: Do not run this script as root."
    return 1
  fi
  return 0
}

require_root() {
  if [ "$(id -u)" != "0" ]; then
    redmsg "ERROR: please run as normal user w/ sudo"
    return 1
  fi

  if [ -z $SUDO_USER ]; then
    redmsg "ERROR: please run as normal user w/ sudo"
    return 1
  fi
  return 0
}

require_wsl() {
  if ! is_wsl; then
    redmsg "ERROR: This script requires WSL2."
    return 1
  fi
  return 0
}


require_winhome() {
  get_default_win_user() {
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

  if ! is_wsl; then
    return 0
  fi

  path="$HOME/winhome"
  if [[ -L "$path" && -d "$path" ]]; then
    return 0
  fi

  echo "Creating winhome link in $HOME/winhome..."
  win_drive="$(basename "$(grep drvfs /proc/self/mounts | head -n 1 | cut -d' ' -f 2)")"
  win_user="$(get_default_win_user "$win_drive")"
  win_home="/mnt/$win_drive/Users/$win_user"
  if [ -d "$win_home" ]; then
    ln -vsf "$win_home" "$HOME/winhome"
  fi
}

is_ubuntu() {
  if grep -q "ID=ubuntu" /etc/os-release; then
    return 0
  fi

  return 1
}

is_debian() {
  if grep -q "ID=debian" /etc/os-release; then
    return 0
  fi

  return 1
}

is_wsl() {
  if command -v wslpath > /dev/null 2>&1; then
    return 0
  fi

  return 1
}

chkpath() {
  # no programs specified
  if [[ $# -eq 0 ]]; then
    return 1
  fi

  for prog in "$@"; do
    command -v "$prog" > /dev/null 2>&1 || return 1
  done
}

chkpkg() {
  # no packages specified
  if [[ $# -eq 0 ]]; then
    return 1
  fi

  for pkg in "$@"; do
    dpkg -V "$pkg" > /dev/null 2>&1 || return 1
  done
}

download() {
  # no urls specified
  if [[ $# -eq 0 ]]; then
    return 1
  fi

  cd "$DOWNLOADS"
  for url in "$@"; do
    filename=$(basename "$url")
    if [[ ! -f "$filename" ]]; then
      logmsg "Downloading $url..."
      curl -sfLO "$url"
    fi
  done
}

if [[ "${DEBUG:-}" ]]; then
  echo "*** Debug mode enabled ***"
  set -o xtrace
else
  set +o xtrace
fi

if is_wsl; then
  require_winhome
  DOWNLOADS="$HOME/winhome/Downloads"
else
  DOWNLOADS="$HOME/Downloads"
  mkdir -p "$DOWNLOADS"
fi
