#!/usr/bin/env bash

RED="\033[1;31m"
NOCOLOR="\033[0m"

colorecho() {
	echo -e "${RED}${1}${NOCOLOR}"
}

ZSH="${HOME}/.oh-my-zsh"
ZSSH_CUSTOM="$ZSH/custom"

sudo apt install zsh -y && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc
colorecho '[*] Re-login'
colorecho '[*] Run "sudo chsh -s `which zsh`"'

cp "$ZSH/themes/robbyrussell.zsh-theme" "$ZSH_CUSTOM/themes/robbyrussell.zsh-theme"
sed -i 's/%c/%(4~|%-1~\/…\/%2~|%3~)/g' "$ZSH_CUSTOM/themes/robbyrussell.zsh-theme"

cat << 'EOT' >> ~/.zshrc

# Resolve DOTFILES_DIR
if [ -d "$HOME/.dotfiles" ]; then
    DOTFILES_DIR="$HOME/.dotfiles"
else
    echo "Unable to find dotfiles, exiting..."
    return
fi

# Source dotfiles
for DOTFILE in "$DOTFILES_DIR"/system/.*; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
done
EOT
