#!/usr/bin/env bash

# Problem: tmux doesn't have access to pbcopy and pbpaste on OS X.
# Solution: https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
# New Problem: not every system I distribute my dotfiles to is going to
#   need this, and some may not have the app.
# Solution: this.

# 1. Are we on an OS X machine?
if [[ $OSTYPE != darwin* ]]; then 
    # Nope; don't bother.
    /usr/bin/env $SHELL
    exit
fi

# 2. Does reattach-to-user-namespace exist in path?
if ! which reattach-to-user-namespace > /dev/null; then 
    # Nope; don't bother.
    /usr/bin/env $SHELL
    exit
fi

reattach-to-user-namespace -l $SHELL