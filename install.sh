#!/bin/bash

. ./install-dotfiles.sh

if command -v pip >/dev/null; then
  pip install ipython ipdb python-language-server mypy
fi

if [[ $(uname) = Darwin ]]; then
  . mac-packages.sh
elif command -v apt-get >/dev/null; then
  . apt-packages.sh
elif command -v yum >/dev/null; then
  . yum-packages.sh
else
  echo no known package manager installed
fi

# install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# import iTerm preferences if on MacOS
if [[ $(uname) = Darwin ]]; then
  defaults import com.googlecode.iterm2 iterm2.plist
else
  echo change preferred font in your terminal emulator to "Inconsolata Nerd Font"
  echo also, you might want to change the background to '#2C001E rgb(45, 0, 30)'
  # other possible todos
  # enable Night Light https://vitux.com/how-to-activate-night-light-on-ubuntu-desktop/
  # use Tweaks to: dark theme, startup Guake
fi
