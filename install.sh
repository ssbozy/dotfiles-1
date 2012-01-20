#! /usr/bin/env bash

function print_standard() {
    echo -e "\033[0m$1\033[0m"
}
function print_green() {
    echo -e "\033[0;32m$1\033[0m"
}
function print_red() {
    echo -e "\033[0;31m$1\033[0m"
}
function print_yellow() {
    echo -e "\033[0;33m$1\033[0m"
}

if [[ "$(dirname install.sh)" != "." ]]; then 
    print_red "install.sh must be run from the dotfiles folder."
    exit
fi

DOT_DIR=`pwd`
BAK_DIR="$HOME/.dotfiles-$(date +%Y%m%d.%H%M)"
mkdir -p $BAK_DIR

EXCLUDE="install.sh README .git bin"

# Go through all files in $DOT_DIR, excluding those in $EXCLUDE
# If that file exists in $HOME, back it up to $HOME/dot-bak-%Y%m%d.%H%M/
# Make a symlink to the file in $HOME/

cd $HOME

print_green "Symlinking dot files."
for dotfile_path in `find $DOT_DIR -maxdepth 1 -not -ipath "$DOT_DIR/.git/*" -and -not -ipath "$DOT_DIR/bin/*"`; do 
    dotfile_name=`basename $dotfile_path`
    for ignored in $EXCLUDE; do
        if [[ "$dotfile_name" == "$ignored" ]]; then
            print_yellow "Ignoring $dotfile_name";
            continue 2;
        fi
    done

    if [[ -f $HOME/$dotfile_name || -L $HOME/$dotfile_name ]]; then
        # Back this sucker up!
        print_green "Moving $HOME/$dotfile_name to $BAK_DIR/$dotfile_name"
        mv $HOME/$dotfile_name $BAK_DIR/$dotfile_name
    fi

    print_green "Symlinking $dotfile_path in $(pwd)"
    ln -s $dotfile_path
done

print_green "Symlinking bin files."

# Now, take care of ~/bin/
if [[ -d $HOME/bin || -L $HOME/bin ]]; then
    print_green "Moving $HOME/bin to $BAK_DIR/bin"
    mv $HOME/bin $BAK_DIR/bin
fi
ln -s $DOT_DIR/bin

if [[ "$MACHTYPE" == *redhat* ]] && ! which tmux >> /dev/null; then
    read -p "Install tmux? [y/n, default n] " install_tmux
    if [[ "$install_tmux" == "y" ]]; then
        sudo rpm -ivh http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm && sudo yum install tmux
    fi
fi

# Let's make sure we have pretties
if [[ "$MACHTYPE" == *redhat* ]]; then
    print_red "Unable to source stuff in redhat for some dumb reason?"
else
    source $HOME/.bashrc
    bind -f $HOME/.inputrc
fi

# Go home
cd $HOME

# Here is where I need to figure out the hostname, and copy the correct bip.conf file
$HOSTBIPCONF="$DOT_DIR/.bip/bip.$HOSTNAME.conf"
if [[ -f $HOSTBIPCONF ]]; then
    ln -s $HOSTBIPCONF .bip/.bip.conf
fi
