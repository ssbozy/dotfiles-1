#! /usr/bin/env bash

if [[ "$(dirname install.sh)" != "." ]]; then 
    echo "install.sh must be run from the dotfiles folder."
    exit
fi

DOT_DIR=`pwd`
BAK_DIR="$HOME/.dotfiles-$(date +%Y%m%d.%H%M)"

EXCLUDE="install.sh README .git bin"

# Go through all files in $DOT_DIR, excluding those in $EXCLUDE
# If that file exists in $HOME, back it up to $HOME/dot-bak-%Y%m%d.%H%M/
# Make a symlink to the file in $HOME/

cd $HOME

echo "Symlinking dot files."
for dotfile_path in `find $DOT_DIR -type f -and -not -ipath "$DOT_DIR/.git/*" -and -not -ipath "$DOT_DIR/bin/*"`; do 
    dotfile_name=`basename $dotfile_path`
    for ignored in $EXCLUDE; do
        if [[ "$dotfile_name" == "$ignored" ]]; then
            echo "Ignoring $dotfile_name";
            continue 2;
        fi
    done

    if [[ -f $HOME/$dotfile_name || -L $HOME/$dotfile_name ]]; then
        # Back this sucker up!
        echo "Moving $HOME/$dotfile_name to $BAK_DIR/$dotfile_name"
        mv $HOME/$dotfile_name $BAK_DIR/$dotfile_name
    fi

    echo "Symlinking $dotfile_path in $(pwd)"
    ln -s $dotfile_path
done

echo "Symlinking bin files."

# Now, take care of ~/bin/
if [ -d $HOME/bin || -L $HOME/bin ]; then
    echo "Moving $HOME/bin to $BAK_DIR/bin"
    mv $HOME/bin $BAK_DIR/bin
fi
ln -s $DOT_DIR/bin

if [[ "$MACHTYPE" == *redhat* ]]; then
    read -p "Install tmux? [y/n, default n]" install_tmux
    if [[ "$install_tmux" == "y" ]]; then
        sudo rpm -ivh http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm && sudo yum install tmux
    fi
fi

# Let's make sure we have pretties
source $HOME/.bashrc
bind -f $HOME/.inputrc

# Go home
cd $HOME
