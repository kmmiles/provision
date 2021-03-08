#!/bin/bash

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
