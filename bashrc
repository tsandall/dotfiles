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
shopt -s histappend
complete -d cd pushd
export TERM="xterm-256color"
export PS1='\u:\W\$ '
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export HISTCONTROL=erasedups:ignorespace
export HISTSIZE=99999
export EDITOR="emacs -nw"

# Paths
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.gem/ruby/2.0.0/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$PATH
export PATH=$HOME/scratch/google-cloud-sdk/bin:$PATH

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if [ -f $HOME/venv/bin/activate ]; then
    source $HOME/venv/bin/activate
fi

export KUBECONFIG=$(__join ':' $HOME/.kube/config.d/*)

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

alias emacs='emacs'
alias grep='grep --color=auto -E'
alias ll='ls -l -h'

case $( uname -s ) in
    Darwin)
        alias ls='ls -G'
        ;;
    *)
        alias pbcopy='xclip -selection clipboard'
		alias pbpaste='xclip -selection clipboard -out'
        alias ls='ls --color=auto'
        ;;
esac

alias gist='gist -c -p'

function json_loads {
    python -c 'import json; import sys; print json.load(sys.stdin)' | jq
}
