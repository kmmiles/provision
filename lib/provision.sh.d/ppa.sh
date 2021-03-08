#!/bin/bash

################################################################################
# Add ppa repository if it doesn't already exist
# Arguments:
#   ppa url e.g. ppa:aslatter/ppa
# Returns:
#   1 if bad ppa url
################################################################################
ppa_add() {
  ppa="${1:-}"
  if [[ -z "$ppa" ]]; then
    return 1
  fi

  # sanity check the ppa url
  p="$(echo "$ppa" | cut -d':' -f 1)"
  if [[ "$p" != "ppa" ]]; then
    return 1
  fi

  p="$(echo "$ppa" | cut -d':' -f 2)"
  if ! grep -q "$p" /etc/apt/sources.list.d/*.list; then
    sudo add-apt-repository "$ppa"
  fi
}
