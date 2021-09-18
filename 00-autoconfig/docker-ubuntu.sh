#!/usr/bin/env bash

RED="\033[1;31m"
NOCOLOR="\033[0m"

colorecho() {
        echo -e "[*] ${RED}${1}${NOCOLOR}"
}

sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce -y
sudo systemctl enable docker --now
sudo usermod -aG docker ${USER}

colorecho 'Re-login'
colorecho 'Run "docker run --rm hello-world"'
colorecho 'Install docker-compose: https://docs.docker.com/compose/install/#install-compose-on-linux-systems'
