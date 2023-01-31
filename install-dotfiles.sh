#!/bin/bash

mkdir ~/.vim
mkdir ~/.config
mkdir ~/.config/nvim
mkdir ~/.config/ranger

[ -L ~/bin ] && rm ~/bin
ln -i -s "$PWD/bin" ~/bin
[ -L ~/.config/nvim/ftplugin ] && rm ~/.config/nvim/ftplugin
ln -i -s "$PWD/ftplugin" ~/.config/nvim/ftplugin
[ -L ~/.warp/themes ] && rm ~/.warp/themes
ln -i -s "$PWD/warp-themes" ~/.warp/themes

ln -fs "$PWD/.ackrc" ~/.ackrc
ln -fs "$PWD/.ripgreprc" ~/.ripgreprc
ln -fs "$PWD/common-config.sh" ~/common-config.sh
ln -fs "$PWD/config.zsh" ~/config.zsh
ln -fs "$PWD/.gitconfig" ~/.gitconfig
ln -fs "$PWD/.gitignore_global" ~/.gitignore_global
ln -fs "$PWD/.inputrc" ~/.inputrc
ln -fs "$PWD/.pryrc" ~/.pryrc
ln -fs "$PWD/.psqlrc" ~/.psqlrc
ln -fs "$PWD/.mongorc.js" ~/.mongorc.js
ln -fs "$PWD/.pythonrc.py" ~/.pythonrc.py
ln -fs "$PWD/.vimrc" ~/.vimrc
ln -fs "$PWD/init.lua" ~/.config/nvim/init.lua
ln -fs "$PWD/rc.conf" ~/.config/ranger/rc.conf
ln -fs "$PWD/scope.sh" ~/.config/ranger/scope.sh
ln -fs "$PWD/starship.toml" ~/.config/starship.toml
/bin/cp -f "$PWD/.zshrc" ~/.zshrc
