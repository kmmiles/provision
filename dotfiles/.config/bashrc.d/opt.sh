set bell-style none
shopt -s checkwinsize
shopt -s histappend

GIT_EDITOR=nvim
VISUAL=nvim
EDITOR=nvim
HISTCONTROL=ignoredups:erasedups  # no duplicate entries
HISTSIZE=100000                   # many commands in ongoing session memory
HISTFILESIZE=100000               # many lines in .bash_history

export GIT_EDITOR VISUAL EDITOR HISTCONTROL HISTSIZE HISTFILESIZE
