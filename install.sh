#! /usr/bin/env bash

if [[ "$(dirname install.sh)" != "." ]]; then 
    echo "install.sh must be run from the dotfiles folder."
    exit
fi

DOT_DIR=`pwd`
BAK_DIR="$HOME/dot-bak-$(date +%Y%m%d.%H%M)"

EXCLUDE="install.sh README .git bin"

# Go through all files in $DOT_DIR, excluding those in $EXCLUDE
# If that file exists in $HOME, back it up to $HOME/dot-bak-%Y%m%d.%H%M/
# Make a symlink to the file in $HOME/

cd $HOME

mkdir -p $BAK_DIR/bin

for dotfile_path in `find $DOT_DIR -type f -and -not -ipath "$DOT_DIR/.git/*" -and -not -ipath "$DOT_DIR/bin/*"`; do 
    dotfile_name=`basename $dotfile_path`
    for ignored in $EXCLUDE; do
        if [[ "$dotfile_name" == "$ignored" ]]; then
            echo "Ignoring $dotfile_name";
            continue 2;
        fi
    done

    if [ -f $HOME/$dotfile_name ]; then
        # Back this sucker up!
        echo "Moving $HOME/$dotfile_name to $BAK_DIR/$dotfile_name"
        mv $HOME/$dotfile_name $BAK_DIR/$dotfile_name
    fi

    echo "Symlinking $dotfile_path in $(pwd)"
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
        echo "Moving $HOME/bin/$binfile_name to $BAK_DIR/bin/$binfile_name"
        mv $HOME/bin/$binfile_name $BAK_DIR/bin/$binfile_name
    fi

    echo "Symlinking $binfile_path in $(pwd)"
    ln -s $binfile_path
done

if [[ "$MACHTYPE" == *redhat* ]]; then
    read -p "Install tmux? [y/n, default n]" install_tmux
    if [[ "$install_tmux" == "y" ]]; then
        sudo rpm -ivh http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm && sudo yum install tmux
    fi
fi
