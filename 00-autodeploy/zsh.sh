#!/usr/bin/env bash

RED="\033[1;31m"
NOCOLOR="\033[0m"

colorecho() {
	echo -e "${RED}${1}${NOCOLOR}"
}

apt install zsh -y && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i 's/plugins=(git)/plugins=(git virtualenv virtualenvwrapper zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc
colorecho '[*] Re-login'

cp "$ZSH/themes/robbyrussell.zsh-theme" "$ZSH_CUSTOM/themes/robbyrussell.zsh-theme"
colorecho '[*] replace "%c" with "%(4~|%-1~/…/%2~|%3~)"'

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
