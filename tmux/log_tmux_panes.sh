#!/usr/bin/env bash

LOG_DIR="$HOME/tmux_logs/$(date +%Y-%m-%d)"
mkdir -p "$LOG_DIR"

DEBUG_LOG="$HOME/tmux_logs/cron_debug.log"

HISTORY_LIMIT="50000"

log_debug() {
    echo "[$(date)] $1" >> "$DEBUG_LOG"
}

log_debug "[*] Starting tmux logging script"

if ! pgrep tmux > /dev/null; then
    log_debug "[-] No tmux processes found"
    exit 0
fi

SESSIONS=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

if [ -z "$SESSIONS" ]; then
    log_debug "[-] No tmux sessions found"
    exit 0
fi

log_debug "[*] Found sessions: $SESSIONS"

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

for SESSION in $SESSIONS; do
    WINDOWS=$(tmux list-windows -t "$SESSION" -F "#{window_index}" 2>/dev/null)
  
    for WINDOW in $WINDOWS; do
        PANES=$(tmux list-panes -t "$SESSION:$WINDOW" -F "#{pane_index}" 2>/dev/null)
    
        for PANE in $PANES; do
            TARGET="$SESSION:$WINDOW.$PANE"

            FILENAME="$LOG_DIR/tmux-history-$SESSION-$WINDOW-$PANE-${TIMESTAMP}.log"

            log_debug "[+] Processing pane: $TARGET"

            tmux capture-pane -J -S "-${HISTORY_LIMIT}" -p -t "$TARGET" > "$FILENAME" 2>> "$DEBUG_LOG"

            sed -i "1i# Tmux log for session: $SESSION, window: $WINDOW, pane: $PANE\n# Captured at: $(date)\n\n" "$FILENAME"
        done
    done
done

log_debug "[*] Finished processing all panes"
