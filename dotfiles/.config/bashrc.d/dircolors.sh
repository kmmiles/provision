#!/bin/bash

if [[ -x /usr/bin/dircolors ]]; then
  if [[ -f "$HOME"/.dir_colors ]]; then
    eval "$(dircolors -b "$HOME"/.dir_colors)" 
  else
    eval "$(dircolors -b)"
  fi
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
