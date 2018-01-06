#!/bin/bash

ln -s $PWD/bin ~/bin
ln -s $PWD/.bashrc ~/.bashrc
ln -s $PWD/.bash_aliases ~/.bash_aliases
ln -s $PWD/.bash_completions ~/.bash_completions
ln -s $PWD/.gitconfig ~/.gitconfig
ln -s $PWD/.gitignore_global ~/.gitignore_global
ln -s $PWD/.inputrc ~/.inputrc
ln -s $PWD/.pryrc ~/.pryrc
ln -s $PWD/.psqlrc ~/.psqlrc
ln -s $PWD/.mongorc.js ~/.mongorc.js
ln -s $PWD/.pythonrc.py ~/.pythonrc.py
ln -s $PWD/.vimrc ~/.vimrc

if [[ $(uname) = Darwin ]]; then
  . mac-packages.sh
else
  . linux-packages.sh
fi

# install more most up-to-date git and vim
git clone https://github.com/powerline/fonts ~/Downloads/fonts
pushd ~/Downloads/fonts
./install.sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
popd

if [[ $(uname) = Darwin ]]; then
  defaults import com.googlecode.iterm2 iterm2.plist
else
  echo change preferred font in your terminal emulator to "Inconsolata for Powerline"
  echo also, you might want to change the background to '#2C001E rgb(45, 0, 30)'
fi

# once atom is installed, run this:
# apm install apathy-theme color-picker emmet file-icons highlight-selected linter linter-eslint pigments script vim-mode-plus
