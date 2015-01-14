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
export HISTSIZE=15000
export HISTFILESIZE=15000
# Store timestamps
export HISTTIMEFORMAT='%F %T '
if [ -n "$BASH_VERSION" ] && [ -n "$POSIXLY_CORRECT" ]; then
    # Append to history file, don't overwrite.
    shopt -s histappend
    # don't try to complete on nothing
    shopt -s no_empty_cmd_completion
fi

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

export LC_ALL="C"



PS1=""
PS1_DATE=1
PS1_USER=1
PS1_HOST=1
PS1_PATH=1
PS1_NEWLINE=1
# 23:00:09 <@fancybone> hey, what's the last character of a bash prompt called
# 23:00:18 <@brett_h> dicks
# 23:00:23 <@fancybone> dicks it is
PS1_DICKS="\n# "
PS1_DATE_COLOR=$COLOR_LIGHT_BLUE
PS1_USER_COLOR=$COLOR_LIGHT_BLUE
PS1_HOST_COLOR=$COLOR_LIGHT_BLUE
PS1_PATH_COLOR=$COLOR_LIGHT_CYAN

alias grep='grep --color=auto'
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"

if [[ -f $HOME/.screensaver.sh ]]; then
    source .screensaver.sh
fi


function tmuxx() {
  if [[ "$1" == "bv" && -e /gitwork/Hubs-Core/ ]]; then
    cd /gitwork/Hubs-Core/
  fi
  tmux att -t "$1" || tmux new -s "$1"
}

# for crontabs, git, etc.
export EDITOR=vim

# Write commands to history as soon as they are typed
# http://briancarper.net/blog/248/
export PROMPT_COMMAND='history -a'

# iPython should live in ~/.ipython/
export IPYTHONDIR=~/.ipython/

# If block needed due to Ubuntu bug: https://bugs.launchpad.net/ubuntu/+source/lightdm/+bug/1097903
if [ -n "$BASH_VERSION" ] && [ -n "$POSIXLY_CORRECT" ]; then
    # http://bclary.com/blog/2006/07/20/pipefail-testing-pipeline-exit-codes/
    set -o pipefail
fi

###################
# OS specific stuff
###################
case $OSTYPE in
    darwin*)
        # OS X

        alias ls='ls -G' # -G colorizes ls output
        alias updatedb='sudo /usr/libexec/locate.updatedb'

        if [[ -f /usr/libexec/java_home ]]; then
            export JAVA_HOME="$(/usr/libexec/java_home)"
        fi

        # Optional bash_completion
        if [ -f `brew --prefix`/etc/bash_completion ]; then
            alias bash_completion='source `brew --prefix`/etc/bash_completion'
            #source `brew --prefix`/etc/bash_completion
        fi

        # git bash completion
        if [ -f $HOME/git-completion.bash ]; then
            source $HOME/git-completion.bash
        fi

        # Use OS X emacs
        if [ -d /Applications/Emacs.app/Contents/MacOS/bin ]; then
            export PATH=/Applications/Emacs.app/Contents/MacOS/bin:$PATH
            alias emacs='emacsclient -n' # Open new files from command line in existing frame
            EDITOR="emacsclient"
        fi

        # Android Development Tools
        if [ -d "/Applications/Android Studio.app/sdk" ]; then
            export PATH="/Applications/Android Studio.app/sdk/platform-tools:${PATH}"
            export PATH="/Applications/Android Studio.app/sdk/tools:${PATH}"
        fi

        # Homebrew
        export PATH=/usr/local/bin:/usr/local/sbin:$PATH

        export SUDO_PROMPT="Seno akta gamat: "
    ;;
    *)
        # Everything else
        alias ls='ls --color=auto'
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
    "plishin.local")
        # BazaarVoice Macbook

        export MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=128m"

        # Come on, weechat, let's have some unicode
        export LC_ALL="en_US.UTF-8"

        # Not committing this to public repo, might contain sensitive stuff
        if [ -f $HOME/.bazaarvoice.bashrc ]; then
            source $HOME/.bazaarvoice.bashrc
        fi
        if [ -f /tmp/abba_servers ]; then
            source /tmp/abba_servers
        fi
        if [ -f /tmp/connections_reporting_servers ]; then
            source /tmp/connections_reporting_servers
        fi

        # Docker crap
        export DOCKER_HOST=tcp://192.168.59.103:2376
        export DOCKER_CERT_PATH=/Users/pavel.lishin/.boot2docker/certs/boot2docker-vm
        export DOCKER_TLS_VERIFY=1

        # Open file in IntelliJ from command line
        alias idea="open -b com.jetbrains.intellij"
    ;;
    "vodkamat.netomat.net" | "austin" | "austin.local" | "addison")
        # My Macbook
        #TODO this hostname is temporary, damnit, this thing should be called "austin"

        # Prompt
        PS1_DATE_COLOR=$COLOR_LIGHT_GREEN
        PS1_USER_COLOR=$COLOR_LIGHT_GREEN
        PS1_HOST_COLOR=$COLOR_LIGHT_GREEN
        PS1_PATH_COLOR=$COLOR_LIGHT_CYAN

        # Aliases
        alias mirror=/Users/pavel/projects/mirror/mirror.py
        alias 4ch='/Users/pavel/projects/mirror/mirror.py --4ch'
        alias updatedb="LC_ALL='C' sudo gupdatedb --prunepaths='/Volumes'"  # Don't index any external drives, or anything mounted via sshfs, etc.
        alias php=fakephp

        # Make sure tmux can display UTF data correctly
        alias tmux='tmux -u'

        # Android
        export PATH=/Users/pavel/Downloads/android/adt-bundle-mac-x86_64-20130219/sdk/platform-tools:$PATH

        alias restart_growl="killall GrowlHelperApp; open -b com.Growl.GrowlHelperApp"

        # Launch tinyur desktop screenshot monitor
        # *after* my happy Tmux session starts, so we don't get multiples.
        # if ! ps ax | egrep tinyu[r].py > /dev/null && which tinyur.py > /dev/null; then
        #     nohup tinyur.py 2>&1 >> ~/tinyur.log &
        # fi

        # Bash completion, obv.
        # if [ -f `brew --prefix`/etc/bash_completion ]; then
        #     source `brew --prefix`/etc/bash_completion
        # fi

        # Virtualenv Wrapper
        # if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
        #     source /usr/local/bin/virtualenvwrapper.sh
        # fi

        # Start tmux
        # if ! tmux has-session -t startup 1>/dev/null 2>/dev/null; then
        #     tmux -u new-session -d -s startup
        # fi


        # ec2-api-tools
        export JAVA_HOME="$(/usr/libexec/java_home)"
        test -e $HOME/.ec2 && export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
        test -e $HOME/.ec2 && export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
        export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"

        # I don't know why, but when I try to attach tmux in TotalTerminal,
        # it refuses to show UTF8 characters. So fuck it! This really only runs
        # once per boot, anyway.
        #ONLY attach in visor
        # if [[ $COLUMNS -gt 120 ]]; then tmux att -t startup fi

        if [ -f /Applications/XAMPP/xamppfiles/bin/php ]; then
            alias xphp='/Applications/XAMPP/xamppfiles/bin/php'
            alias xmysql='/Applications/XAMPP/xamppfiles/bin/mysql'
        fi
        if [ -f /Applications/MAMP/bin/php/php5.3.6/bin/php ]; then
            alias mphp='/Applications/MAMP/bin/php/php5.3.6/bin/php'
            alias mmysql='/Applications/MAMP/Library/bin/mysqll'
        fi

        #TODO these might have to be global
        export CLICOLOR=1
        export LSCOLORS=ExFxCxDxBxegedabagacad

        # Load RVM into a shell session *as a function*
        [[ -s "/Users/pavel/.rvm/scripts/rvm" ]] && source "/Users/pavel/.rvm/scripts/rvm"

        # Weechat UTF8 support, hopefully.
        export LC_ALL=en_US.UTF-8

        export NODE_PATH="$NODE_PATH;/usr/local/lib/node_modules"

        ### Set iTerm2 window/tab title
        # $1 = type; 0 - both, 1 - tab, 2 - title
        # rest = text
        setTerminalText () {
            # echo works in bash & zsh
            local mode=$1 ; shift
            echo -ne "\033]$mode;$@\007"
        }
        stt_both  () { setTerminalText 0 $@; }
        stt_tab   () { setTerminalText 1 $@; }
        stt_title () { setTerminalText 2 $@; }


    ;;
    "newyork")
        # Ubuntu desktop, at home.

        # Start synergys, unless it's already running
        if ! ps ax | grep synergy[s] > /dev/null; then
            synergys -c $HOME/.synergy.newyork.conf
        fi
        # alternatively, i might actually start working on my new macbook
        # since SYNERGY and EMACS don't FUCKING WORK WELL TOGETHER
        # better UNSUBJUGATE MYSELF http://debbugs.gnu.org/cgi-bin/bugreport.cgi?bug=4008
            #if ! ps ax | grep synergy[c] > /dev/null; tehn
        #    synergyc -f -n newyork 192.168.0.11 # gotta figure out a permanent ip for adison
        #fi
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
    "yonk")
        # My slicehost server
        if [[ "$TERM" == "xterm-256color" ]]; then
            # Screen can't handle the power of my mac
            export TERM=xterm-color
        fi
    ;;
    "fancybone.xen.prgmr.com")
        # My prgmr server
        # Gotta say somethin'
        true
    ;;
    "champ" | "boom")
        # Work servers

        PS1_DATE_COLOR=$COLOR_LIGHT_GREEN
        PS1_USER_COLOR=$COLOR_LIGHT_GREEN
        PS1_HOST_COLOR=$COLOR_YELLOW
        PS1_PATH_COLOR=$COLOR_LIGHT_CYAN

        # Update ForwardAgent settings
        [[ -f $HOME/bin/grabssh.sh ]] && $HOME/bin/grabssh.sh

        # No idea why /sbin/ isn't in path by default
        export PATH=/sbin/:$PATH

        # Path to python 2.6
        export PATH=/opt/py26/usr/local/bin/:$PATH
        # Path to Ruby 1.9.2
        export PATH=/opt/ruby192/bin/:$PATH

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
    # TODO ಠ_ಠ
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


if [ -f ~/.localbashrc ]; then
    # Maybe I'm on a system I don't want to stick in the repo,
    # but I still need/want to customize
    . ~/.localbashrc
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
