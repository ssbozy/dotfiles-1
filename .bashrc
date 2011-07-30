# ~/.bashrc: executed by bash(1) for non-login shells.

# if not running interactively, don't do anything
[ -z "$PS1" ] && return

COLOR_BLACK="\[\033[0;30m\]"
COLOR_BLUE="\[\033[0;34m\]"
COLOR_GREEN="\[\033[0;32m\]"
COLOR_CYAN="\[\033[0;36m\]"
COLOR_RED="\[\033[0;31m\]"
COLOR_PURPLE="\[\033[0;35m\]"
COLOR_BROWN="\[\033[0;33m\]"
COLOR_LIGHT_GRAY="\[\033[0;37m\]"
COLOR_DARK_GRAY="\[\033[1;30m\]"
COLOR_LIGHT_BLUE="\[\033[1;34m\]"
COLOR_LIGHT_GREEN="\[\033[1;32m\]"
COLOR_LIGHT_CYAN="\[\033[1;36m\]"
COLOR_LIGHT_RED="\[\033[1;31m\]"
COLOR_LIGHT_PURPLE="\[\033[1;35m\]"
COLOR_YELLOW="\[\033[1;33m\]"
COLOR_WHITE="\[\033[1;37m\]"
COLOR_CLEAR="\[\033[0m\]"

# Default prompt
PS1="${COLOR_YELLOW}\u@\h$COLOR_CLEAR:${COLOR_YELLOW}\D{%Y-%m-%d %H:%M:%S}$COLOR_CLEAR:$COLOR_LIGHT_CYAN$\w$COLOR_CLEAR
\$ "

# Bash-specific options

# Don't add this shit to history
export HISTIGNORE="sudo shutdown:sudo re:bg:fg" 
# Ignore duplicates, and commands that start with a space
export HISTCONTROL=ignoredups:ignorespace
# Remember a lot.
export HISTSIZE=5000
export HISTFILESIZE=5000
# Append to history file, don't overwrite.
shopt -s histappend
# don't try to complete on nothing
shopt -s no_empty_cmd_completion
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
# Uh, I think this is actually fucking shit up.
# shopt -s checkwinsize

if [ -d "${HOME}/bin" ]; then
    export PATH=${HOME}/bin:$PATH
fi

alias grep='grep --color=auto'


###################
# OS specific stuff
###################
case $OSTYPE in
    darwin*)
        # OS X
        alias ls='ls -G'
        # git should use textmate for commit messages
        # crontab should use textmate, too; we have to pull the _wait trick.
        export EDITOR=mate_wait
        
    ;;
    *)
        # Everything else
        alias ls='ls --color=auto'
        # git should use vim for commit messages
        export EDITOR=vim
    ;;
esac

#####################
# Host specific stuff
#####################
case $HOSTNAME in
    "vodkamat.netomat.net" | "austin")
        # My Macbook
        #TODO this hostname is temporary, damnit, this thing should be called "austin"

        # Prompt
        export PS1="[${COLOR_LIGHT_GREEN}\D{%Y-%m-%d %H:%M:%S}$COLOR_CLEAR] ${COLOR_LIGHT_GREEN}\u@\h${COLOR_CLEAR}:${COLOR_LIGHT_CYAN}\w${COLOR_CLEAR}\n\$ "
        
        # Aliases
        alias mirror=/Users/pavel/projects/mirror/src/mirror.py
        alias 4ch='/Users/pavel/projects/mirror/src/mirror.py --4ch'
        alias updatedb="LC_ALL='C' sudo gupdatedb --prunepaths='/Volumes'"  # Don't index any external drives, or anything mounted via sshfs, etc.
        
        # MacPorts
        export PATH=/opt/local/bin:/opt/local/sbin:$PATH
        
        # If there isn't a tmux session currently running, then this is the first
        # terminal window we've opened, and it's going to get pinned to the top
        # with visor - I want tmux to automatically launch here.
        if ! tmux has-session -t startup 1>/dev/null 2>/dev/null; then
            # For some reason, if you launch tmux right away,
            # it looks like this: http://i.imgur.com/8Qkq4.png
            sleep 3
            
            # Create new session, with initial window
            tmux new-session -d -s startup -n 'background' "/usr/bin/env bash $HOME/.bashrc-startup"

            # Create new window to work in, after the 0th window.
            tmux new-window -a -t startup:1
            # Focus on second window
            tmux select-window -t startup:2

            # Attach tmux
            tmux attach-session -t startup
        fi
        
        # Bash completion, obv.
        if [ -f `brew --prefix`/etc/bash_completion ]; then
            #source `brew --prefix`/etc/bash_completion
            cat /dev/null
        fi

        # Virtualenv Wrapper
        if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
            #source /usr/local/bin/virtualenvwrapper.sh
            cat /dev/null
        fi

        #TODO these might have to be global
        export CLICOLOR=1
        export LSCOLORS=ExFxCxDxBxegedabagacad        
    ;;
    "newyork")
        # Ubuntu desktop, at home.

        # Start synergys, unless it's already running
        if ! ps ax | grep synergys | grep -v grep > /dev/null; then
            synergys
        fi
        
    ;;
    "vodka")
        # My virtualbox

        export PS1="[${COLOR_LIGHT_CYAN}\D{%Y-%m-%d %H:%M:%S}$COLOR_CLEAR] ${COLOR_LIGHT_CYAN}\u@\h${COLOR_CLEAR}:${COLOR_LIGHT_GREEN}\w${COLOR_CLEAR}\n\$ "

        # enable programmable completion features (you don't need to enable
        # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
        # sources /etc/bash.bashrc).
        if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
            . /etc/bash_completion
        fi

        # Update ForwardAgent settings
        [[ -f $HOME/grabssh.sh ]] && $HOME/grabssh.sh

        # Lol, node.js
        export PATH=$HOME/local/node/bin:$PATH

    ;;
    "champ" | "boom")
        # Work servers

        export PS1="[${COLOR_LIGHT_GREEN}\D{%Y-%m-%d %H:%M:%S}$COLOR_CLEAR] ${COLOR_LIGHT_GREEN}\u@\h${COLOR_CLEAR}:${COLOR_LIGHT_CYAN}\w${COLOR_CLEAR} \$ "

        # Update ForwardAgent settings
        [[ -f $HOME/grabssh.sh ]] && $HOME/grabssh.sh
        
    ;;
    "moobox")
        # Work server under my desk

        export PS1="[${COLOR_LIGHT_GREEN}\D{%Y-%m-%d %H:%M:%S}$COLOR_CLEAR] ${COLOR_LIGHT_GREEN}\u@\h${COLOR_CLEAR}:${COLOR_LIGHT_CYAN}\w${COLOR_CLEAR} \$ "

        # Update ForwardAgent settings
        [[ -f $HOME/grabssh.sh ]] && $HOME/grabssh.sh
        
        # Start synergyc, unless it's already running
        if ! ps ax | grep synergyc | grep -v grep > /dev/null; then
            synergyc austin.netomat.net
        fi
    ;;
    *)
        # Everything else
        
    ;;
esac
