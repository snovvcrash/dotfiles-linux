#!/usr/bin/env bash

git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
${HOME}/.fzf/install

git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
build-fzf-tab-module

sed -i 's/cursor_y \* 2 > window_height/cursor_y \* 1\.8 > window_height/g' ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab/lib/ftb-tmux-popup
