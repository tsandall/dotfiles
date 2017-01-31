#!/usr/bin/env bash

[ -z "$PS1" ] && return

# ---------------------------------
# Exports
# ---------------------------------

# Terminal setup
set -o vi
shopt -s histappend
complete -d cd pushd
export TERM="xterm-256color"
export PS1='\u:\W\$ '
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export HISTCONTROL=erasedups
export HISTSIZE=99999
export EDITOR="vim"

# Paths
export GOPATH=$HOME/go
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/bin/sbt/bin:$PATH
export PATH=$HOME/lib/scala-2.11.6/bin:$PATH
export PATH=$HOME/.gem/ruby/2.0.0/bin:$PATH
export PATH=$GOPATH/bin:$PATH

if [ -f $HOME/venv/bin/activate ]; then
    source $HOME/venv/bin/activate
fi

# ---------------------------------
# Prompt
# ---------------------------------

source $HOME/.dotfiles/promptrc

# ---------------------------------
# Utility Functions/Aliases
# ---------------------------------

alias vi='vim'
alias :e='vim'
alias :q='exit'
alias :w='sync'
alias grep='grep --color=auto -E'
alias ll='ls -l -h'

case $( uname -s ) in
    Darwin) alias ls='ls -G';;
    *)      alias ls='ls --color=auto';;
esac

alias gist='gist -c -p'
alias kc='kubectl'

function cdp {
    cd $(python -c "import os.path as _, ${1}; print _.dirname(_.realpath(${1}.__file__[:-1]))")
}

function denter {
    CONTAINER_ID=$(docker ps | grep "$1" | awk '{print $1}' | head -n 1)
    docker exec -it $CONTAINER_ID bash
}

function dclear {
    docker kill $(docker ps -a -q) || true
    docker rm $(docker ps -a -q) || true
}
