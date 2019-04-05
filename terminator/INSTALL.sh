mkdir -p ${HOME}/.config/terminator/plugins
wget "https://raw.githubusercontent.com/EliverLara/terminator-themes/master/plugin/terminator-themes.py" -O ${HOME}/.config/terminator/plugins/terminator-themes.py
rm ${HOME}/.config/terminator/config
ln -sv ${HOME}/.dotfiles/terminator/config ${HOME}/.config/terminator/config
