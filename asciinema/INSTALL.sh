rm ${HOME}/.config/asciinema/config
mkdir -p ${HOME}/.config/asciinema
ln -sv ${HOME}/.dotfiles/asciinema/config ${HOME}/.config/asciinema/config
# asciinema auth
# echo -n 'TOKEN' > ${HOME}/.config/asciinema/install-id
# asciinema rec 'FILENAME.CAST'
# ^D to stop recording
# asciinema upload 'FILENAME.CAST'
