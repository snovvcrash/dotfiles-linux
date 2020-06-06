#!/usr/bin/env bash

sudo apt install wget git xclip cmake -y
rm -rf ${HOME}/.tmux*
git clone "https://github.com/tmux-plugins/tpm" ${HOME}/.tmux/plugins/tpm
ln -sv ${HOME}/.dotfiles/tmux/.tmux.conf ${HOME}/.tmux.conf
git clone "https://github.com/thewtex/tmux-mem-cpu-load" ${HOME}/.tmux/plugins/tmux-mem-cpu-load
cd ${HOME}/.tmux/plugins/tmux-mem-cpu-load
cmake .
make
sudo make install
cd -
