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
if [ -d "/var/lib/gems/1.8/bin" ]; then
    export PATH=/var/lib/gems/1.8/bin:$PATH
fi
if [ -d "${HOME}/.gem/ruby/1.8/bin" ]; then
    export PATH=${HOME}/.gem/ruby/1.8/bin:$PATH
fi

PS1=""
PS1_DATE=1
PS1_USER=1
PS1_HOST=1
PS1_PATH=1
PS1_NEWLINE=1
# 23:00:09 <@fancybone> hey, what's the last character of a bash prompt called
# 23:00:18 <@brett_h> dicks
# 23:00:23 <@fancybone> dicks it is
PS1_DICKS="\n$ "
PS1_DATE_COLOR=$COLOR_LIGHT_BLUE
PS1_USER_COLOR=$COLOR_LIGHT_BLUE
PS1_HOST_COLOR=$COLOR_LIGHT_BLUE
PS1_PATH_COLOR=$COLOR_LIGHT_CYAN

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

# This is mostly a placeholder.
case $MACHTYPE in
    *redhat-linux-gnu)
        # RedHat machine. Whatever.
    ;;
    *)
        # Everything else;
    ;;
esac


#####################
# Host specific stuff
#####################
case $HOSTNAME in
    "vodkamat.netomat.net" | "austin" | "addison")
        # My Macbook
        #TODO this hostname is temporary, damnit, this thing should be called "austin"

        # Prompt
        PS1_DATE_COLOR=$COLOR_LIGHT_GREEN
        PS1_USER_COLOR=$COLOR_LIGHT_GREEN
        PS1_HOST_COLOR=$COLOR_LIGHT_GREEN
        PS1_PATH_COLOR=$COLOR_LIGHT_CYAN

        # Aliases
        alias mirror=/Users/pavel/projects/mirror/src/mirror.py
        alias 4ch='/Users/pavel/projects/mirror/src/mirror.py --4ch'
        alias updatedb="LC_ALL='C' sudo gupdatedb --prunepaths='/Volumes'"  # Don't index any external drives, or anything mounted via sshfs, etc.
        alias omacs='open -b org.gnu.Emacs'

        # MacPorts
        export PATH=/opt/local/bin:/opt/local/sbin:$PATH
        
        # If there isn't a tmux session currently running, then this is the first
        # terminal window we've opened, and it's going to get pinned to the top
        # with visor - I want tmux to automatically launch here.
        if ! tmux has-session -t startup 1>/dev/null 2>/dev/null; then

            if [[ ! -f /tmp/starting_tmux ]]; then
                touch /tmp/starting_tmux
                
                # For some reason, if you launch tmux right away,
                # it looks like this: http://i.imgur.com/8Qkq4.png
                # So let's wait, and check for $COLUMNS - if it's more than 120,
                # we're in visor!
                # sleep 3

                if [[ $COLUMNS -gt 120 ]]; then
        
                    # Create new session, with initial window
                    tmux new-session -d -s startup -n 'background' "/usr/bin/env bash $HOME/.bashrc-startup"

                    # Create new window to work in, after the 0th window.
                    tmux new-window -a -n 'bash' -t startup:0
                    # Focus on second window
                    tmux select-window -t startup:1

                    # Attach tmux
                    tmux attach-session -t startup
                fi
                
                rm /tmp/starting_tmux
            fi
        fi
        
        # Launch tinyur desktop screenshot monitor
        if ! ps ax | egrep tinyu[r] > /dev/null && which tinyur.py > /dev/null; then
            nohup tinyur.py 0<&- 1>$HOME/tinyur.log 2>$HOME/tinyur.log &
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
            synergys -c $HOME/.synergy.newyork.conf
        fi
        
    ;;
    "vodka")
        # My virtualbox

        PS1_DATE_COLOR=$COLOR_LIGHT_CYAN
        PS1_USER_COLOR=$COLOR_LIGHT_CYAN
        PS1_HOST_COLOR=$COLOR_LIGHT_CYAN
        PS1_PATH_COLOR=$COLOR_LIGHT_GREEN

        # enable programmable completion features (you don't need to enable
        # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
        # sources /etc/bash.bashrc).
        if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
            . /etc/bash_completion
        fi

        # Update ForwardAgent settings
        [[ -f $HOME/bin/grabssh.sh ]] && $HOME/bin/grabssh.sh

        # Lol, node.js
        export PATH=$HOME/local/node/bin:$PATH

    ;;
    "champ" | "boom")
        # Work servers

        PS1_DATE_COLOR=$COLOR_LIGHT_GREEN
        PS1_USER_COLOR=$COLOR_LIGHT_GREEN
        PS1_HOST_COLOR=$COLOR_YELLOW
        PS1_PATH_COLOR=$COLOR_LIGHT_CYAN

        # Update ForwardAgent settings
        [[ -f $HOME/bin/grabssh.sh ]] && $HOME/bin/grabssh.sh
        
    ;;
    "moobox")
        # Work server under my desk

        PS1_DATE_COLOR=$COLOR_LIGHT_GREEN
        PS1_USER_COLOR=$COLOR_LIGHT_GREEN
        PS1_HOST_COLOR=$COLOR_YELLOW
        PS1_PATH_COLOR=$COLOR_LIGHT_CYAN

        # Update ForwardAgent settings
        [[ -f $HOME/bin/grabssh.sh ]] && $HOME/bin/grabssh.sh
        
        # Start synergyc, unless it's already running
        if ! ps ax | grep synergyc | grep -v grep > /dev/null; then
            synergyc austin.netomat.net
        fi
    ;;
    *)
        # Everything else
        
    ;;
esac


if [[ "$USER" == "root" ]]; then
    PS1_USER_COLOR=$COLOR_RED
    PS1_DICKS="${COLOR_RED} $ ${COLOR_CLEAR}"
fi

# prompt
if [[ $PS1_DATE == 1 ]]; then
    PS1="${PS1}[${PS1_DATE_COLOR}\D{%Y-%m-%d %H:%M:%S}$COLOR_CLEAR] "
fi
if [[ $PS1_USER == 1 ]]; then
    PS1="${PS1}${PS1_USER_COLOR}\u$COLOR_CLEAR"
fi
if [[ $PS1_HOST == 1 ]]; then
    PS1="${PS1}${PS1_HOST_COLOR}@\h$COLOR_CLEAR"
fi
if [[ $PS1_PATH == 1 ]]; then
    PS1="${PS1}:${PS1_PATH_COLOR}\w$COLOR_CLEAR"
fi
PS1="${PS1}${PS1_DICKS}"
export PS1
