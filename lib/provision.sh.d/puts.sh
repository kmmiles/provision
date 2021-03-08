#!/bin/bash

################################################################################
# Functions to print a message in various colors
# Globals:
#   None
# Arguments:
#   The message
################################################################################
puts()  { printf "%s\n" "${1}" ; }
putsr() { printf "%s\n" "${TEXT_BOLD}${TEXT_RED}${1}${TEXT_NORMAL}" ; }
putsg() { printf "%s\n" "${TEXT_BOLD}${TEXT_GREEN}${1}${TEXT_NORMAL}" ; }
putsb() { printf "%s\n" "${TEXT_BOLD}${TEXT_BLUE}${1}${TEXT_NORMAL}" ; }
putsy() { printf "%s\n" "${TEXT_BOLD}${TEXT_YELLOW}${1}${TEXT_NORMAL}" ; }
