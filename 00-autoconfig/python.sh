#!/usr/bin/env bash

RED="\033[1;31m"
NOCOLOR="\033[0m"

colorecho() {
	echo -e "[*] ${RED}${1}${NOCOLOR}"
}

# Python3 (pip + venv)
sudo apt install python3-pip -y
sudo python3 -m pip install --upgrade pip
sudo apt install python3-venv -y

# Python2 (interpreter + pip)
#sudo apt install python2.7 -y && sudo ln -sv /usr/bin/python2.7 /usr/bin/python
curl https://bootstrap.pypa.io/get-pip.py | sudo python

# Pipenv
sudo python3 -m pip install pipenv

# Pipx
sudo python3 -m pip install pipx
pipx ensurepath

# Poetry
sudo python3 -m pip install poetry
mkdir $ZSH_CUSTOM/plugins/poetry
poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
colorecho "Add poetry to your list of plugins in .zshrc"
