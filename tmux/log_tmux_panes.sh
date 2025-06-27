#!/usr/bin/env bash

log_debug() {
    echo "[$(date)] $1" >> "$DEBUG_LOG"
}

remove_empty_lines_from_end_of_file() {
    local file=$1
    local temp=$(cat $file)
    printf '%s\n' "$temp" > "$file"
}

LOG_DIR="$HOME/.tmux_logs/$(date +%Y-%m-%d)"
mkdir -p "$LOG_DIR"

DEBUG_LOG="$HOME/.tmux_logs/cron_debug.log"

HISTORY_LIMIT="50000"

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

            BASE_FILENAME="tmux-history-$SESSION-$WINDOW-$PANE"

            TEMP_FILE="$LOG_DIR/${BASE_FILENAME}_${TIMESTAMP}.tmp"

            log_debug "[*] Capturing pane: $TARGET to $TEMP_FILE"

            tmux capture-pane -J -S "-${HISTORY_LIMIT}" -p -t "$TARGET" > "$TEMP_FILE" 2>> "$DEBUG_LOG"
            remove_empty_lines_from_end_of_file "$TEMP_FILE"

            sed -i "1i# Tmux log for session: $SESSION, window: $WINDOW, pane: $PANE\n# Captured at: $(date)\n\n" "$TEMP_FILE"

            EXISTING_FILE=$(find "$LOG_DIR" -name "${BASE_FILENAME}_*.log" -type f -printf "%T@ %p\n" 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2)

            KEEP_NEW=1
            if [ -n "$EXISTING_FILE" ]; then
                NEW_SIZE=$(stat -c %s "$TEMP_FILE")
                OLD_SIZE=$(stat -c %s "$EXISTING_FILE")

                if [ "$NEW_SIZE" -eq "$OLD_SIZE" ]; then
                    if cmp -s <(tail -n +5 "$TEMP_FILE") <(tail -n +5 "$EXISTING_FILE"); then
                        log_debug "[*] Content unchanged, not creating new log file"
                        KEEP_NEW=0
                    fi
                fi
            fi

            if [ "$KEEP_NEW" -eq 1 ]; then
                NEW_FILE="$LOG_DIR/${BASE_FILENAME}_${TIMESTAMP}.log"

                mv "$TEMP_FILE" "$NEW_FILE"

                log_debug "[+] Created new log file: $NEW_FILE"
            else
                rm "$TEMP_FILE"
            fi
        done
    done
done

log_debug "[*] Finished processing all panes"
