dotfiles-linux (WSL)
==========

## Clone

```
~$ git clone https://github.com/snovvcrash/dotfiles-windows .dotfiles
~$ ln -sv ${USERPROFILE}/.dotfiles/wsl ${HOME}/.dotfiles
```

## Init

```
~/.dotfiles$ git submodule update --init --remote
~/.dotfiles$ git submodule foreach --recursive 'git checkout $(git config -f $toplevel/.gitmodules submodule.$name.branch || echo master)'
```

## Update

```
~/.dotfiles$ cd wsl
~/.dotfiles/wsl$ git commit -am 'Changes in wsl repo'
~/.dotfiles/wsl$ git push origin wsl
~/.dotfiles/wsl$ cd ..
~/.dotfiles$ git commit -am 'Chnages in dotfiles-windows repo'
~/.dotfiles$ git push origin master
```
