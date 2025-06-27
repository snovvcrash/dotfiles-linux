#!/usr/bin/env bash

SESSION=$1
WINDOW=$2
PANE=$3
DATE=$(date +"%Y%m%d-%H%M%S")
LOG_DIR="$HOME/.tmux_logs"
mkdir -p "$LOG_DIR"

tmux pipe-pane -t "${SESSION}:${WINDOW}.${PANE}" -o "ansifilter > $LOG_DIR/tmux-${DATE}-${SESSION}-${WINDOW}-${PANE}.log"
