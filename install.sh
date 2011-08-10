#! /usr/bin/env bash

if [[ "$(dirname install.sh)" != "." ]]; then 
    echo "install.sh must be run from the dotfiles folder."
    exit
fi

DOT_DIR=`pwd`
BAK_DIR="$HOME/dot-bak-$(date +%Y%m%d.%H%M)"

EXCLUDE="install.sh README .git bin"

function _try_bak() { 
    echo $1
}


# Go through all files in $DOT_DIR, excluding those in $EXCLUDE
# If that file exists in $HOME, back it up to $HOME/dot-bak-%Y%m%d.%H%M/
# Make a symlink to the file in $HOME/

cd $HOME

mkdir -p $HOME/$BAK_DIR/bin

for dotfile_path in `find $DOT_DIR -type f -and -not -ipath '*/.git/*'`; do 
    dotfile_name=`basename $dotfile_path`
    for ignored in $EXCLUDE; do
        if [[ "$dotfile_name" == "$ignored" ]]; then
            echo "Ignoring $dotfile_name";
            continue 2;
        fi
    done

    if [ -f $HOME/$dotfile_name ]; then
        # Back this sucker up!
        echo "Moving $HOME/$dotfile_name to $HOME/$BAK_DIR/$dotfile_name"
        mv $HOME/$dotfile_name $HOME/$BAK_DIR/$dotfile_name
    fi

    ln -s $dotfile_path
done

# Now, take care of ~/bin/
if [ ! -d $HOME/bin ]; then
    echo "Creating $HOME/bin"
    mkdir $HOME/bin;
fi

cd $HOME/bin/

for binfile_path in `find $DOT_DIR/bin`; do 
    binfile_name=`basename $binfile_path`
    if [ -f $HOME/bin/$binfile_name ]; then
        # Back this sucker up!
        echo "Moving $HOME/bin/$binfile_name to $HOME/$BAK_DIR/bin/$binfile_name"
        mv $HOME/bin/$binfile_name $HOME/$BAK_DIR/bin/$binfile_name
    fi

    ln -s $binfile_path
done





#maybe add something to add myself as a user?

# Assume that it's been cloned into ~/dotfiles/

# mkdir ~/dot-bak/
# cd dotfiles
# find . -type f -not -ipath '*.git/*' -exec mv ~/{} ~/dot-bak/ \;
# cd ~
# find dotfiles/ -type f -not -ipath '*.git/*' -exec ln -s {} \;

# For our CentOS VMs, if I want tmux, I gotta:
# rpm -ivh http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
# yum install tmux
