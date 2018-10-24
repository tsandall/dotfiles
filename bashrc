#!/usr/bin/env bash

[ -z "$PS1" ] && return

function __join() {
    local IFS=$1
    shift
    echo "$*"
}

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
export HISTCONTROL=erasedups:ignorespace
export HISTSIZE=99999
export EDITOR="vim"

# Paths
export GOPATH=$HOME/go
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.gem/ruby/2.0.0/bin:$PATH
export PATH=$GOPATH/bin:$PATH
if [ -f $HOME/venv/bin/activate ]; then
    source $HOME/venv/bin/activate
fi

export KUBECONFIG=$(__join ':' $HOME/.kube/config.d/*):$HOME/.kube/config

# Colors for man
export LESS_TERMCAP_mb=$'\e'"[1;31m"
export LESS_TERMCAP_md=$'\e'"[1;31m"
export LESS_TERMCAP_me=$'\e'"[0m"
export LESS_TERMCAP_se=$'\e'"[0m"
export LESS_TERMCAP_ue=$'\e'"[0m"
export LESS_TERMCAP_us=$'\e'"[1;32m"

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
alias k='kubectl'
alias d='docker'
alias code='/Applications/Visual\ Studio\ Code.app/Contents/MacOS/Electron'

function cdp {
    cd $(python -c "import os.path as _, ${1}; print _.dirname(_.realpath(${1}.__file__[:-1]))")
}

function json_loads {
    python -c 'import json; import sys; print json.load(sys.stdin)' | jq
}
