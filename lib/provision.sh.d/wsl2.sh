#!/bin/bash

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

handle_wsl2() {
  # for wsl2 we need some links in $HOME to exist
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
}


