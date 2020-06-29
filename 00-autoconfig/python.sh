#!/usr/bin/env bash

RED="\033[1;31m"
NOCOLOR="\033[0m"

colorecho() {
	echo -e "${RED}${1}${NOCOLOR}"
}

# Python2 (interpreter + pip)
#sudo apt install python2.7 -y && sudo ln -sv /usr/bin/python2.7 /usr/bin/python
curl https://bootstrap.pypa.io/get-pip.py |sudo python

# Python3 (pip + venv)
sudo apt install python3-pip -y
sudo python3 -m pip install --upgrade pip
sudo apt install python3-venv -y

sudo apt install virtualenvwrapper -y
colorecho "[*] Check if virtualenvwrapper.sh path is correct: $HOME/.dotfiles/system/.virtualenv"
