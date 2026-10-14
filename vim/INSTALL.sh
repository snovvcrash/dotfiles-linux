rm -rf ${HOME}/{.vimrc,.vim}
ln -sv ${HOME}/.dotfiles/vim/vimrc ${HOME}/.vimrc

mkdir -p ~/.vim/{autoload,bundle} ~/.vim/pack/plugins/{start,opt}
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

#git clone https://github.com/PProvost/vim-ps1.git ~/.vim/pack/plugins/start/vim-ps1
git clone https://github.com/PProvost/vim-ps1.git ~/.vim/bundle/vim-ps1
