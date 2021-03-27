# shell options
setopt autocd
unsetopt beep
bindkey -v

# autocompletion
zstyle ':completion:*' menu select
autoload -Uz compinit
compinit

# suggestions
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# history file settings
HISTFILE=~/.cache/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# editor settings
GIT_EDITOR=nvim
VISUAL=nvim
EDITOR=nvim
export GIT_EDITOR VISUAL EDITOR

# prompt
PROMPT='%B%F{240}%1~%f%b [%(?.%F{green}√.%F{red}%?)%f] $ '

# PATH's
typeset -U PATH path
ponybin=$HOME/.local/share/ponyup/bin
flutterbin=$HOME/.local/src/flutter/bin
emacsbin=~/.emacs.d/bin
path=(
  "$HOME/.local/bin"
  "$emacsbin"
  "$flutterbin"
  "$ponybin"
  "$path[@]"
)
export PATH
GOPATH="$HOME"/go
export GOPATH

# aliases
has() { type "$1" &> /dev/null ; } 
has exa         &&  alias ls='exa --git'
has prettyping  &&  alias ping='prettyping --nolegend'
has btm         &&  alias btm='btm --battery --color gruvbox'
has fnm         &&  alias nvm='fnm'
has nvim        &&  alias vim='nvim'
has python3     &&  alias httpd='python3 -m http.server'
has dpkg        &&  alias apt-provides='dpkg -S'
has less        &&  alias less='less -R'

# less colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# dircolors
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

# x11 for wsl2
if has wslpath; then
  DISPLAY=$(grep nameserver /etc/resolv.conf | awk '{print $2; exit;}'):0.0
  export DISPLAY
fi

# fnm 
has fnm && eval "$(fnm env)"

