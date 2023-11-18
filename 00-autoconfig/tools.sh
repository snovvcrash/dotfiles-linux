#!/usr/bin/env bash

# -- apt -------------------------------------------------------------

sudo apt install autossh -y
sudo apt install bat -y
sudo apt install clipman -y
sudo apt install flameshot -y
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

# sshx
curl -sSf https://sshx.io/get | sh

# -- snap ------------------------------------------------------------

sudo apt install snapd -y
sudo service snapd start
sudo apparmor_parser -r /etc/apparmor.d/*snap-confine*
sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap*
#export PATH="$PATH:/snap/bin"

sudo snap install codium --classic
sudo snap install mdless

# -- src -------------------------------------------------------------

# Obfuscator-LLVM 13.x
git clone -b llvm-13.x --single-branch https://github.com/heroims/obfuscator ~/tools/ollvm && cd ~/tools/ollvm
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_NEW_PASS_MANAGER=OFF ../llvm
sed -i 's/LLVM_TOOL_CLANG_BUILD:BOOL=OFF/LLVM_TOOL_CLANG_BUILD:BOOL=ON/g' CMakeCache.txt
sed -i "s|LLVM_EXTERNAL_CLANG_SOURCE_DIR:PATH=|LLVM_EXTERNAL_CLANG_SOURCE_DIR:PATH=`realpath ../clang`|g" CMakeCache.txt
make -j7
## Backup & replace clang bins
sudo mv /usr/bin/clang /usr/bin/clang.bak
sudo mv /usr/bin/clang++ /usr/bin/clang++.bak
sudo cp bin/clang /usr/bin/clang
sudo cp bin/clang++ /usr/bin/clang++
## Wclang (cross-compile with clang on Linux/Unix for Windows)
git clone https://github.com/tpoechtrager/wclang ~/tools/wclang && cd ~/tools/wclang
cmake -DCMAKE_INSTALL_PREFIX=_prefix_ .
make && make install
export PATH="`pwd`/_prefix_/bin:$PATH"
## Backup & replace clang libs
sudo cp -R /lib/llvm-13/lib/clang/13.0.1/include/ /lib/llvm-13/lib/clang/13.0.1/include.backup/
cd ~/tools/ollvm/build/lib/clang/13.0.1/
sudo cp -R include/ /lib/llvm-13/lib/clang/13.0.1/
## Check
x86_64-w64-mingw32-clang++ -v
