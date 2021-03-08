#!/bin/bash

# functions dealing with paths

################################################################################
# Convert absolute path to path relative to current working directory
# Arguments:
#   Absolute path
# Outputs:
#   Relative path
################################################################################
relpath() { realpath -s --relative-to="$PWD" "$1" ; }

################################################################################
# Convert path to absolute
# Arguments:
#   Path
# Outputs:
#   Absolute path
################################################################################
abspath() { realpath -s "$1" ; }

phonepath() {
  find /run/user/"$(id -u)"/gvfs/ -mindepth 1 -maxdepth 1 -type d | \
    while read -r _dir; do
      dir="$_dir/Internal shared storage"
      if [[ -d "$dir" ]]; then
        echo "$dir"
        return 0
      fi
    done
  return 1
}

