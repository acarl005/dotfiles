#!/bin/bash

set -e

mkdir -p ~/.vim
mkdir -p ~/.warp
mkdir -p ~/.config

rm -rf ~/.config/nvim
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
mkdir ~/.config/nvim/lua/user/

[ -L ~/bin ] && rm ~/bin
ln -i -s "$PWD/bin" ~/bin
[ -L ~/.config/nvim/ftplugin ] && rm ~/.config/nvim/ftplugin
ln -i -s "$PWD/ftplugin" ~/.config/nvim/ftplugin
[ -L ~/.warp/themes ] && rm ~/.warp/themes
ln -i -s "$PWD/warp-themes" ~/.warp/themes
[ -L ~/.config/joshuto ] && rm ~/.config/joshuto
ln -i -s "$PWD/joshuto" ~/.config/joshuto

ln -fs "$PWD/.ripgreprc" ~/.ripgreprc
ln -fs "$PWD/common-config.sh" ~/common-config.sh
ln -fs "$PWD/config.zsh" ~/config.zsh
ln -fs "$PWD/.gitconfig" ~/.gitconfig
ln -fs "$PWD/.gitignore_global" ~/.gitignore_global
ln -fs "$PWD/.inputrc" ~/.inputrc
ln -fs "$PWD/.psqlrc" ~/.psqlrc
ln -fs "$PWD/.pythonrc.py" ~/.pythonrc.py
ln -fs "$PWD/starship.toml" ~/.config/starship.toml
ln -fs "$PWD/init.lua" ~/.config/nvim/lua/user/init.lua
ln -fs "$PWD/.bashrc" ~/.bashrc
command cp -f "$PWD/.zshrc" ~/.zshrc
command cp -f "$PWD/.bash_profile" ~/.bash_profile
