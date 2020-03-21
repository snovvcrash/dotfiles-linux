#!/usr/bin/env bash

# Usage: ./tmux-upd.sh <VERSION>

if [[ "$#" -ne 1 ]]; then
	echo "Usage: bash $0 VERSION"
	exit
fi

VERSION="$1"

apt remove -y tmux
apt install -y wget git xclip tar libevent-dev libncurses-dev

wget "https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz"
tar xf tmux-${VERSION}.tar.gz
rm -f tmux-${VERSION}.tar.gz
cd tmux-${VERSION}
./configure
make
make install

cd ..
rm -rf /usr/local/src/tmux-*
mv tmux-${VERSION} /usr/local/src
killall -9 tmux

ln -sv /usr/local/bin/tmux /usr/bin/tmux

# tmux-cfg.sh (get config)
rm -rf ${HOME}/.tmux*
git clone "https://github.com/tmux-plugins/tpm" ${HOME}/.tmux/plugins/tpm
wget "https://raw.githubusercontent.com/snovvcrash/dotfiles-linux/master/tmux/.tmux.conf" -O ${HOME}/.tmux.conf

# Fix permissions
USER_HOME=`getent passwd ${SUDO_USER} | cut -d: -f6`
chown -R ${SUDO_USER} ${USER_HOME}/.tmux*
