#!/usr/bin/env bash

RED="\033[1;31m"
NOCOLOR="\033[0m"

colorecho() {
	echo -e "[*] ${RED}${1}${NOCOLOR}"
}

ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$ZSH/custom"
DOTFILES_DIR="$HOME/.dotfiles"

sudo apt install zsh -y && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/mafredri/zsh-async "$ZSH_CUSTOM/plugins/async"

for theme in "$DOTFILES_DIR/zsh/themes/"*; do
	filename=`basename "$theme"`
	ln -sv "$theme" "$ZSH_CUSTOM/themes/$filename"
done

for plugin in "$DOTFILES_DIR/zsh/plugins/"*; do
	dirname=`basename "$plugin" .zsh`
	filename="$dirname.plugin.zsh"
	mkdir -p "$ZSH_CUSTOM/plugins/$dirname"
	ln -sv "$plugin" "$ZSH_CUSTOM/plugins/$dirname/$filename"
done

rm "$HOME/.zshrc"
ln -sv "$HOME/.dotfiles/zsh/zshrc" "$HOME/.zshrc"

colorecho 'Run "chsh -s `which zsh`"'
colorecho 'Re-login'
