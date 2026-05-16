#!/bin/sh

i=1
tmux list-sessions -F '#{session_name}' | while read -r name; do
    printf "%s\n" "$name" "$i" "switch-client -t $name"
    i=$((i+1))
done | {
    menu_args=""
    while IFS= read -r line; do
        menu_args="$menu_args \"$line\""
    done
    eval "tmux display-menu -M -T 'Sessions' -x M -y S $menu_args"
}
