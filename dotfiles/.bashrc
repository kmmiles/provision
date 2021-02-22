# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

################################################################################
# My additions
################################################################################

# colors
TEXT_BOLD=$(tput bold)
TEXT_RED=$(tput setaf 1)
TEXT_GREEN=$(tput setaf 2)
TEXT_NORMAL=$(tput sgr0)

GIT_EDITOR=vim
VISUAL=vim
EDITOR=vim
HISTCONTROL=ignoredups:erasedups  # no duplicate entries
HISTSIZE=100000                   # many commands in ongoing session memory
HISTFILESIZE=100000               # many lines in .bash_history
PS1='\[\e[33m\]\w\[\e[0m\] [`return_code`]\n\$ '

return_code() {
  rc=$?
  if [[ ${rc} -eq 0 ]]; then
    printf "%s" "${TEXT_BOLD}${TEXT_GREEN}${rc}${TEXT_NORMAL}"
  else
    printf "%s" "${TEXT_BOLD}${TEXT_RED}${rc}${TEXT_NORMAL}"
  fi
}

# exports
export -f return_code
export GIT_EDITOR VISUAL EDITOR HISTCONTROL HISTSIZE HISTFILESIZE IMAGE PS1

# disable dumb bell
set bell-style none

# append to history instead of overwriting
shopt -s histappend

# aliases
if command -v exa > /dev/null 2>&1; then
  alias ls='exa --git'
fi
if command -v prettyping > /dev/null 2>&1; then
  alias ping='prettyping --nolegend'
fi
alias apt-provides='dpkg -S'
alias less='less -R'

# x11 for wsl2 
if command -v wslpath > /dev/null 2>&1; then
  DISPLAY=$(grep nameserver /etc/resolv.conf | awk '{print $2; exit;}'):0.0
  export DISPLAY
fi

# go
export GOPATH=~/go

# PATH
export PATH="$HOME/.local/bin:$HOME/.local/share/ponyup/bin:$PATH"

# dumb
#bind 'set show-all-if-ambiguous on'
#bind 'TAB:menu-complete'
