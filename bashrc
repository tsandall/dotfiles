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
export PATH=/mnt/c/Users/torin/AppData/Local/Programs/Microsoft\ VS\ Code:$PATH

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if [ -f $HOME/venv/bin/activate ]; then
    source $HOME/venv/bin/activate
fi

export KUBECONFIG=$KUBECONFIG:$(__join ':' $HOME/.kube/config.d/*)

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

alias code='Code.exe'
alias emacs='emacs'
alias grep='grep --color=auto -E'
alias ll='ls -l -h'

case $( uname -s ) in
    Darwin)
        alias ls='ls -G'
        ;;
    *)
        alias pbcopy='clip.exe'
        alias pbpaste='powershell.exe Get-Clipboard'
        alias ls='ls --color=auto'
        ;;
esac

alias gist='gist-paste -c -p'

function oq {
    # pipe thru jq to colorize
	opa eval --format pretty --stdin-input 'input' | jq
}

. "$HOME/.cargo/env"

SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

function now_8601_utc {
	date -u +"%Y-%m-%dT%H:%M:%S.000Z"
}

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

cd $HOME