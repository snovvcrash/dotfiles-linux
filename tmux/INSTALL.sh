sudo apt install wget git xclip -y
rm -rf ${HOME}/.tmux*
git clone "https://github.com/tmux-plugins/tpm" ${HOME}/.tmux/plugins/tpm
ln -sv ${HOME}/.dotfiles/tmux/tmux.conf ${HOME}/.tmux.conf
