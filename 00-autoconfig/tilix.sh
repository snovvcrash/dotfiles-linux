#!/usr/bin/env bash

# Good color themes: Nightlion V2, Snazzy

sudo apt install tilix -y
mkdir -p ~/.config/tilix/schemes
git clone --recurse-submodules https://github.com/isacikgoz/gogh-to-tilix /tmp/isacikgoz/gogh-to-tilix
cd /tmp/isacikgoz/gogh-to-tilix
chmod +x install.sh
./install.sh ~/.config/tilix/schemes
cd -
rm -rf /tmp/isacikgoz/gogh-to-tilix
