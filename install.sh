#!/bin/bash

. ./install-dotfiles.sh

if [[ $(uname) = Darwin ]]; then
  . mac-packages.sh
elif command -v apt-get >/dev/null; then
  . apt-packages.sh
elif command -v dnf >/dev/null; then
  . dnf-packages.sh
else
  echo no known package manager installed
fi

# install Vundle to Vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# install Packer to NeoVim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# import iTerm preferences if on MacOS
if [[ $(uname) = Darwin ]]; then
  defaults import com.googlecode.iterm2 iterm2.plist
fi

echo change preferred font in your terminal emulator to "Inconsolata Nerd Font" or similar
