rm -rf ${HOME}/{.vimrc,.vim}
ln -sv ${HOME}/.dotfiles/vim/vimrc ${HOME}/.vimrc

mkdir -p ~/.vim/pack/plugins/{start,opt}

git clone https://github.com/PProvost/vim-ps1.git ~/.vim/pack/plugins/start/vim-ps1
