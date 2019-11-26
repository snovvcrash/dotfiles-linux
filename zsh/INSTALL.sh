rm ${HOME}/.zshrc
ln -sv ${HOME}/.dotfiles/zsh/.zshrc ${HOME}/.zshrc

cp "$ZSH/themes/robbyrussell.zsh-theme" "$ZSH_CUSTOM/themes/robbyrussell.zsh-theme"  # and modify PROMPT with "%(4~|%-1~/…/%2~|%3~)"
