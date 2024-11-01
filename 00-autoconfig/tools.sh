#!/usr/bin/env bash

# -- apt -------------------------------------------------------------

sudo apt install bat lsd -y
sudo apt install clipman -y
sudo apt install flameshot kazam -y
sudo apt install jq -y
sudo apt install keepassx -y
sudo apt install mlocate -y
sudo apt install ncdu -y
sudo apt install remmina -y
sudo apt install resolvconf -y
sudo apt install ripgrep -y
sudo apt install simplescreenrecorder -y
sudo apt install ssh-tools -y
sudo apt install timeshift -y
sudo apt install tree -y
sudo apt install xfce4-clipman -y
sudo apt install bless -y

# Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt install apt-transport-https -y
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install sublime-text -y

# eget
curl https://zyedidia.github.io/eget.sh | sh
sudo mv eget /usr/local/bin
## ipinfo
eget -qs linux/amd64 "ipinfo/cli" --to /tmp && sudo dpkg -i /tmp/ipinfo_*linux_amd64 && rm /tmp/ipinfo_*linux_amd64
## gruyere
mkdir -p ~/tools/gruyere && eget -qs linux/amd64 "savannahostrowski/gruyere" --to ~/tools/gruyere
## anew
mkdir -p ~/tools/anew && eget -qs linux/amd64 "tomnomnom/anew" --to ~/tools/anew
## dex
mkdir -p ~/tools/dex && eget -qs linux/amd64 "nixxxon/dex" --to ~/tools/dex
## tailspin
mkdir -p ~/tools/tailspin && eget -qs linux/amd64 "bensadeh/tailspin" --to ~/tools/tailspin

# sshx
curl -sSf https://sshx.io/get | sh

# croc
curl https://getcroc.schollz.com | bash

# fun
go install github.com/GeertJohan/gomatrix@latest

# -- snap ------------------------------------------------------------

sudo apt install snapd -y
sudo service snapd start
sudo apparmor_parser -r /etc/apparmor.d/*snap-confine*
sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap*
#export PATH="$PATH:/snap/bin"

sudo snap install codium --classic
sudo snap install mdless
sudo snap install procs

# -- browsers --------------------------------------------------------

# LibreWolf (no-telemetry Firefox)
sudo apt update && sudo apt install extrepo -y
sudo extrepo enable librewolf
sudo apt update && sudo apt install librewolf -y

# Brave (no-telemetry Chrome)
sudo apt install curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser
