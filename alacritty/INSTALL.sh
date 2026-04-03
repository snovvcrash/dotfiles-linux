rm -rf ~/.config/alacritty && mkdir -p ~/.config/alacritty
ln -sv ${HOME}/.dotfiles/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
sudo apt install alacritty -y
