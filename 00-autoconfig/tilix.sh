#!/usr/bin/env bash

# Themes:
#   https://github.com/storm119/Tilix-Themes/blob/master/Themes.md
#   https://github.com/isacikgoz/gogh-to-tilix

# Some good color themes: Nightlion V2, Orchis, Snazzy

cd tmp
wget https://github.com/gnunn1/tilix/releases/download/1.9.4/tilix-1.9.4_x86_64-linux-gnu.zip -O tilix.zip
unzip tilix.zip
sudo cp tilix-1.9.4/bin/tilix /usr/bin/
sudo cp -r tilix-1.9.4/share/* /usr/share/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
rm -rf tilix-1.9.4 tilix.zip
cd -

sudo apt install dconf-editor dconf-cli -y

mkdir -p ~/.config/tilix/schemes
git clone --recurse-submodules https://github.com/isacikgoz/gogh-to-tilix /tmp/gogh-to-tilix
cd /tmp/gogh-to-tilix
chmod +x install.sh
./install.sh ~/.config/tilix/schemes
cd -

rm -rf /tmp/gogh-to-tilix
