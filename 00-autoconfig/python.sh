#!/usr/bin/env bash

# Python3 (pip + venv)
sudo apt install python3-pip -y
sudo python3 -m pip install --upgrade pip
sudo apt install python3-venv -y

# Python 3 (latest interpreter + pip)
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.9 -y
sudo apt install python3.9-distutils -y
curl https://bootstrap.pypa.io/pip/get-pip.py | sudo python3.9

# Python2 (interpreter + pip)
#sudo apt install python2.7 -y && sudo ln -sv /usr/bin/python2.7 /usr/bin/python
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py | sudo python

# Poetry
sudo python3 -m pip install --ignore-installed poetry

# Pipx
sudo python3 -m pip install pipx
pipx ensurepath

# bpython
sudo apt install bpython -y
