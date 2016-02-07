#!/bin/bash

[ -z "$PS1" ] && return

# Thirdparty...
source $HOME/.dotfiles/z.sh
source $HOME/.dotfiles/git-completion.bash

# Shell...
source $HOME/.dotfiles/exportrc
source $HOME/.dotfiles/promptrc
source $HOME/.dotfiles/aliasrc
source $HOME/.dotfiles/developmentrc
