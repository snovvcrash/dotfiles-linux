git clone "https://github.com/tmux-plugins/tpm" ${HOME}/.tmux/plugins/tpm
rm ${HOME}/.tmux.conf
ln -sv ${HOME}/.dotfiles/tmux/.tmux.conf ${HOME}/.tmux.conf
