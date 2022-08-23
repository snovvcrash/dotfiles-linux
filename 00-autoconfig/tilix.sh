#!/usr/bin/env bash

# Themes:
#   https://github.com/storm119/Tilix-Themes/blob/master/Themes.md
#   https://github.com/isacikgoz/gogh-to-tilix

# Some good color themes: Nightlion V2, Orchis, Snazzy

cd tmp
wget https://github.com/gnunn1/tilix/releases/download/1.9.3/tilix.zip
sudo unzip tilix.zip -d /
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
rm tilix.zip
cd -

sudo apt install dconf-editor dconf-cli -y

mkdir -p ~/.config/tilix/schemes
git clone --recurse-submodules https://github.com/isacikgoz/gogh-to-tilix /tmp/isacikgoz/gogh-to-tilix
cd /tmp/isacikgoz/gogh-to-tilix
chmod +x install.sh
./install.sh ~/.config/tilix/schemes
cd -

rm -rf /tmp/isacikgoz/gogh-to-tilix
