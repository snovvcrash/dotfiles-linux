rm ${HOME}/.zshrc
ln -sv ${HOME}/.dotfiles/zsh/.zshrc ${HOME}/.zshrc

# Modify PROMPT with "%(4~|%-1~/…/%2~|%3~)"
cp "$ZSH/themes/robbyrussell.zsh-theme" "$ZSH_CUSTOM/themes/robbyrussell.zsh-theme"

# Hash out export VIRTUAL_ENV_DISABLE_PROMPT=1 and reload ZSH
vi ${HOME}/.oh-my-zsh/plugins/virtualenv/virtualenv.plugin.zsh

# Stash local changes and update oh-my-zsh:
# ==> cd ~/.oh-my-zsh && git stash && upgrade_oh_my_zsh && git stash pop
