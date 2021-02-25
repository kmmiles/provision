#!/usr/bin/env bash

if command -v exa > /dev/null 2>&1; then
  alias ls='exa --git'
fi

if command -v prettyping > /dev/null 2>&1; then
  alias ping='prettyping --nolegend'
fi

if command -v btm > /dev/null 2>&1; then
  alias btm='btm --battery --color gruvbox'
fi

alias apt-provides='dpkg -S'
alias less='less -R'
alias vim='nvim'
