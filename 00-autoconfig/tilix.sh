#!/usr/bin/env bash

# Themes:
#   https://github.com/storm119/Tilix-Themes/blob/master/Themes.md
#   https://github.com/isacikgoz/gogh-to-tilix

# Some good color themes: Nightlion V2, Orchis, Snazzy

sudo apt install tilix -y
mkdir -p ~/.config/tilix/schemes
git clone --recurse-submodules https://github.com/isacikgoz/gogh-to-tilix /tmp/isacikgoz/gogh-to-tilix
cd /tmp/isacikgoz/gogh-to-tilix
chmod +x install.sh
./install.sh ~/.config/tilix/schemes
cd -
rm -rf /tmp/isacikgoz/gogh-to-tilix
