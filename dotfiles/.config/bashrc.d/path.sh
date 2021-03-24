#!/bin/bash

GOBIN=$HOME/.local
PONYBIN=$HOME/.local/share/ponyup/bin
FLUTTERBIN=$HOME/Code/flutter/bin
EMACSBIN=~/.emacs.d/bin
PATH="$HOME/.local/bin:$EMACSBIN:$FLUTTERBIN:$PONYBIN:$PATH"

GOPATH=$HOME/go

export PATH GOPATH
