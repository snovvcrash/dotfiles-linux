mkdir ${HOME}/.ssh/controlmasters
rm ${HOME}/.ssh/config
ln -sv ${HOME}/.dotfiles/ssh/config ${HOME}/.ssh/config
