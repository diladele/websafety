#!/bin/bash
SESSION=$USER

tmux -2 new-session -d -s $SESSION

# setup a window for tailing log files
tmux new-window -t $SESSION:1 -n 'Logs'
tmux split-window -v

# lower pane is for squid log
tmux select-pane -t 1
tmux send-keys "tail -f /var/log/squid/access.log" C-m

# upper pane is for mc and htop
tmux select-pane -t 0
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "htop" C-m
tmux select-pane -t 1
tmux send-keys "mc" C-m

# set default window and attach to session
tmux select-window -t $SESSION:1
tmux -2 attach-session -t $SESSION
