#!/usr/bin/env bash

sudo apt install ranger caca-utils highlight atool w3m poppler-utils mediainfo -y

# https://github.com/ranger/ranger/wiki/Official-user-guide#configuration-files

ranger
q
ranger --copy-config=all
rm ${HOME}/.config/ranger/rc.conf
ln -sv ${HOME}/.dotfiles/ranger/rc.conf ${HOME}/.config/ranger/rc.conf
