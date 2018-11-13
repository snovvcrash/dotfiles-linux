#!/usr/bin/env bash

if [[ "$#" -ne 1 ]]; then
	echo "Usage: bash $0 VERSION"
	exit
fi

VERSION="$1"

sudo apt remove tmux -y
sudo apt install wget tar xclip libevent-dev libncurses-dev -y

wget "https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz"
tar xf tmux-${VERSION}.tar.gz
rm -f tmux-${VERSION}.tar.gz
cd tmux-${VERSION}
./configure
make
sudo make install

cd ..
sudo rm -rf /usr/local/src/tmux-*
sudo mv tmux-${VERSION} /usr/local/src
sudo killall -9 tmux

sudo ln -sv /usr/local/bin/tmux /usr/bin/tmux

