~$ rm ${HOME}/.dotfiles && ln -sv /c/Users/manwi/.dotfiles/wsl .dotfiles
~$ sudo bash -c 'cat << EOF > /etc/wsl.conf
[automount]
root = /
options = "metadata,umask=22,fmask=11"
EOF'

PS > Restart-Service -Name LxssManager
