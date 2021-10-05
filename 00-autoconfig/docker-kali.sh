#!/usr/bin/env bash

RED="\033[1;31m"
NOCOLOR="\033[0m"

colorecho() {
        echo -e "[*] ${RED}${1}${NOCOLOR}"
}

sudo apt install docker.io -y
sudo systemctl enable docker --now
sudo usermod -aG docker $USER
printf "%s\n" "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-ce-archive-keyring.gpg] https://download.docker.com/linux/debian buster stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/docker-ce-archive-keyring.gpg
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y

colorecho 'Re-login'
colorecho 'Run "docker run --rm hello-world"'
colorecho 'Install docker-compose: https://docs.docker.com/compose/install/#install-compose-on-linux-systems'
