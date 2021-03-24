#!/usr/bin/env bash

TEXT_BOLD=$(tput bold)
TEXT_RED=$(tput setaf 1)
TEXT_GREEN=$(tput setaf 2)
TEXT_NORMAL=$(tput sgr0)

PS1='\[\e[33m\]\w\[\e[0m\] [`return_code`]\n\$ '

return_code() {
  rc=$?
  if [[ ${rc} -eq 0 ]]; then
    printf "%s" "${TEXT_BOLD}${TEXT_GREEN}${rc}${TEXT_NORMAL}"
  else
    printf "%s" "${TEXT_BOLD}${TEXT_RED}${rc}${TEXT_NORMAL}"
  fi
}

export -f return_code
export PS1

