#!/bin/sh

# Create new session
tmux new-session -d -s startup

# Create new window to use as background stuff
tmux new-window -a -t startup:0 -n 'background' # Running .bash-startup here quits instantly, killing the window, and thereby closing screen

# Kill the window currently in slot 0
tmux kill-window -t startup:0

# Move "background" to slot 0
tmux move-window -s startup:1 -t startup:0


# Create new window to work in.
tmux new-window -a -t startup:0

# Focus on first window
tmux select-window -t startup:1

# Attach tmux
tmux -2 attach-session -t startup