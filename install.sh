#!/bin/bash

. ./install-dotfiles.sh

if [[ $(uname) = Darwin ]]; then
  . mac-packages.sh
elif command -v apt-get >/dev/null; then
  . apt-packages.sh
elif command -v yum >/dev/null; then
  . yum-packages.sh
else
  echo no known package manager installed
fi

# install Vundle to Vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# install Vim-Plug to NeoVim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qall


# import iTerm preferences if on MacOS
if [[ $(uname) = Darwin ]]; then
  defaults import com.googlecode.iterm2 iterm2.plist
fi

echo change preferred font in your terminal emulator to "Inconsolata Nerd Font" or similar
