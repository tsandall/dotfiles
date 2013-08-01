#!/bin/bash

[ -z "$PS1" ] && return

#if [ -e /etc/bashrc ]; then
#    . /etc/bashrc
#fi

TERM="xterm-256color"
PS1='\u:\W\$ '
#PS1="${SCREENTITLE}${PS1}"

set -o vi

#shopt -s checkwinsize               
shopt -s histappend                 

export HISTCONTROL=erasedups 
export HISTSIZE=99999

export EDITOR="vim"
export SVN_EDITOR="$EDITOR"

alias vi='vim'
alias ack='ack-grep'
alias ctags-create='ctags --recurse --sort=yes --extra=+fq --fields=+i --python-kinds=i'
alias screen-start='screen -d -R -c $HOME/.screenrc -S $1'
alias screen-buffer='vim $HOME/.screen-buffer'
alias :e='vim'
alias :ta='vim -t'
alias :q='exit'
alias :w='sync'
alias grep='grep --color=auto'
alias grep='grep -E'
alias cgrep='find . -type f \( -name *.c -o -name *.cc -o -name *.cpp -o -name *.C -o -name *.h -o -name *.hh -o -name *.hpp \) | xargs grep -n $1'
alias jgrep='find . -type f \( -name *.java \) | xargs grep -n $1'
alias pygrep='find . -type f \( -name "*.py" \) | xargs grep -n $1'
alias cso='pycscope.py -R .'
alias pytop='top -s 2 -p `pidof python|sed s/\ /,/g` $@'
alias hg-pending="find . -maxdepth 2 -type d | grep '\\/.+\\/' | \
xargs -P 8 -n 1 -I x bash -c \
'{ hg summary --remote --cwd x | grep -q outgoing && echo x ; }'"
alias hg-outstanding="find . -maxdepth 2 -type d | grep '\\/.+\\/' | \
xargs -n 1 -I x bash -c \
'{ echo x; hg status --cwd x ; }'"
alias fps='ps auxwww -H'

function go-env {

    if [[ "x$1" == "x" ]]; then
        cd $VIRTUAL_ENV
    else
        cd $VIRTUALENV_DIR/$1
    fi
}

function activate-env {
    if [[ "x$1" == "x" ]]; then
        source $VIRTUALENV_DIR/main27/bin/activate
    else
        source $VIRTUALENV_DIR/$1/bin/activate
    fi
    
    export COVERAGE=`which coverage`
    export PYTHON=`which python`
    export TRIAL=`which trial`
}

function cdp {
    cd $(python -c "import os.path as _, ${1}; print _.dirname(_.realpath(${1}.__file__[:-1]))")
}

function svn-diff-vi {
    svn diff $@ | vi -
}

function svn-status-ignore-unversioned {
    svn status | grep "^([^\? ]|       \*)"
}

function go-dev {
    #ssh tsandall@localhost -p 2222
    cd $DEV
}

# history_of_file
#
# Outputs the full history of a given file as a sequence of
# logentry/diff pairs.  The first revision of the file is emitted as
# full text since there's not previous version to compare it to.
function svn-diff-history() {
    url=$1 # current url of file
    svn log -q $url | grep -E -e "^r[[:digit:]]+" -o | cut -c2- | sort -n | {

#       first revision as full text
        echo
        read r
        svn log -r$r $url@HEAD
        svn cat -r$r $url@HEAD
        echo

#       remaining revisions as differences to previous revision
        while read r
        do
            echo
            svn log -r$r $url@HEAD
            svn diff -c$r $url@HEAD
            echo
        done
    }
}

SSH_AGENT_EXPORTS_FILE=/tmp/ssh-agent-exports

function start-ssh-agent {
    SSHAGENT=/usr/bin/ssh-agent
    SSHAGENTARGS="-s"
    if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
        $SSHAGENT $SSHAGENTARGS > $SSH_AGENT_EXPORTS_FILE
        eval `cat $SSH_AGENT_EXPORTS_FILE`
        /usr/bin/ssh-add
    fi
}

function eval-ssh-agent {
    if [[ -f $SSH_AGENT_EXPORTS_FILE ]]; then
        eval `cat $SSH_AGENT_EXPORTS_FILE` >/dev/null
    fi
}

# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
    MAGENTA="\[\033[0;45m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
       CYAN="\[\033[1;46m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

function set_hg_prompt() {
    INCOMING="" #`hg prompt "{incoming|count}" 2>/dev/null`
    OUTGOING="" #`hg prompt "{outgoing|count}" 2>/dev/null`
    STATUS=`hg prompt "{status"} 2>/dev/null`
    if [[ -z $INCOMING ]] && [[ -z $OUTGOING ]] && [[ -z $STATUS ]]; then
        HG_PROMPT=""
        return
    fi
    if [[ ! -z $INCOMING ]]; then
        INCOMING="${YELLOW}${INCOMING}${COLOR_NONE}"
    fi
    if [[ ! -z $OUTGOING ]]; then
        OUTGOING="${GREEN}${OUTGOING}${COLOR_NONE}"
    fi
    if [[ ${STATUS} == "!" ]]; then
        STATUS="${BLUE}${STATUS}${COLOR_NONE}"
    elif [[ ${STATUS} == "?" ]]; then
        STATUS="${MAGENTA}${STATUS}${COLOR_NONE}"
    fi
    HG_PROMPT="[${INCOMING}${OUTGOING}${STATUS}]"
}

function set_prompt_symbol () {
    if test $1 -eq 0 ; then
        PROMPT_SYMBOL="${LIGHT_GRAY}\$${COLOR_NONE}"
    else
        PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
    fi
}

function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${COLOR_NONE}[${YELLOW}`basename \"$VIRTUAL_ENV\"`${COLOR_NONE}]" #${COLOR_NONE}"
  fi
}

function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  if test -n "$BP_PROJECT_NAME"; then
      BP_PROJECT="(${GREEN}$BP_PROJECT_NAME${COLOR_NONE})"
  fi

  set_hg_prompt
  
  # Set the bash prompt variable.
  PS1="${PYTHON_VIRTUALENV}${BP_PROJECT}${HG_PROMPT}${COLOR_NONE}\u@\h:\w${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt

OS=$(uname -s)

if [[ $OS == "Linux" ]]; then
    source $HOME/.dotfiles/bashrc.linux
elif [[ $OS == "Darwin" ]]; then
    source $HOME/.dotfiles/bashrc.mac
fi

source $HOME/.workrc
export PATH=/usr/share/zookeeper/bin:$PATH
export PATH=$HOME/bin:$PATH

if [ -e $SSH_AGENT_EXPORTS_FILE ]; then
    if [ -z $SSH_AUTH_SOCK ]; then
        eval-ssh-agent
    fi
elif [ -z $SSH_AUTH_SOCK ]; then
    start-ssh-agent
fi

alias ack='ack-grep'
alias ackc='ack-grep --ignore-dir="tests"'

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

function cdl () {

    cd /var/lib/lxc/`ls /var/lib/lxc | grep $1`/rootfs

}

alias dev='ssh -t dev-vm screen -dR $1'

function go-vagrant {
    if [ $# -eq 0 ]; then
        cd  ~/dev/vagrant/`ls ~/dev/vagrant|head -n 1`
    else
        cd ~/dev/vagrant/`ls ~/dev/vagrant | grep $1`
    fi
}

alias gist='gist -p'
