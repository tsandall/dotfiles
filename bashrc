#!/bin/bash

[ -z "$PS1" ] && return

# ---------------------------------
# Exports
# ---------------------------------

set -o vi
shopt -s histappend
complete -d cd pushd

export TERM="xterm-256color"
export PS1='\u:\W\$ '
export HISTCONTROL=erasedups 
export HISTSIZE=99999
export EDITOR="vim"
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/bin/sbt/bin:$PATH
export PATH=$HOME/lib/scala-2.11.6/bin:$PATH
export PATH=$HOME/.gem/ruby/2.0.0/bin:$PATH

if [[ `uname` == "Darwin" ]]; then
    export PATH=$HOME/Library/Python/2.7/bin:$PATH
fi

# ---------------------------------
# Prompt 
# ---------------------------------

source $HOME/.dotfiles/promptrc

# ---------------------------------
# Utility Functions/Aliases
# ---------------------------------

alias vi='vim'
alias screen-start='screen -d -R -c $HOME/.screenrc -S $1'
alias :e='vim'
alias :q='exit'
alias :w='sync'
alias grep='grep --color=auto'
alias grep='grep -E'
alias gist='gist -c -p'
alias mytodo='ack "TODO\(tsandall\)"'

PLATFORM=$(uname)

if [[ "$PLATFORM" == "Darwin" ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

alias ll='ls -l -h'

function venv {
    source $HOME/Development/venv/bin/activate
}

function cdp {
    cd $(python -c "import os.path as _, ${1}; print _.dirname(_.realpath(${1}.__file__[:-1]))")
}

function dminit {
    eval "$(docker-machine env default)"
    echo "ok"
}

function dmssh {
    docker-machine ssh default
}

function dmip {
    docker-machine ip default
}

function denter {
    CONTAINER_ID=$(docker ps | grep "$1" | awk '{print $1}' | head -n 1)
    docker exec -it $CONTAINER_ID bash
}

function dclear {
    docker kill $(docker ps -a -q) || true
    docker rm $(docker ps -a -q) || true
}

function genv {
    if [ -z "$1" ]; then
        echo "Must specify name of target directory."
        return 1
    fi
    z $1
    __genv_rec $PWD
    if [ $? -ne 0 ]; then
        echo "Could not find Go workspace for $PWD."
        return 1
    fi
}

function __genv_rec {
    stat $1/.genv 2>/dev/null 1>&2
    if [ $? -eq 0 ]; then
        export GOPATH=$1
        pathadd $GOPATH/bin
        return 0
    elif [ "$1" != "/" ]; then
        __genv_rec `dirname $1`
        return $?
    else
        return 1
    fi
}

function pathadd() {
    # From
    # http://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

function godeps {
    go list -f '{{ join .Deps "\n" }}' $1
}

[ -f /Users/torin/.travis/travis.sh ] && source /Users/torin/.travis/travis.sh
