#!/usr/bin/env bash

RED="\033[1;31m"
NOCOLOR="\033[0m"

colorecho() {
        echo -e "[*] ${RED}${1}${NOCOLOR}"
}

git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
${HOME}/.fzf/install

git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
sed -i 's/cursor_y \* 2 > window_height/cursor_y \* 1\.8 > window_height/g' "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab/lib/ftb-tmux-popup"

colorecho 'Run "build-fzf-tab-module" from a new shell'
