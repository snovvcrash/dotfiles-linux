#!/usr/bin/env bash

sudo apt install git -y

rm -rf ${HOME}/.tmux*
git clone "https://github.com/tmux-plugins/tpm" ${HOME}/.tmux/plugins/tpm
wget "https://raw.githubusercontent.com/snovvcrash/dotfiles-linux/master/tmux/.tmux.conf" -O ${HOME}/.tmux.conf
