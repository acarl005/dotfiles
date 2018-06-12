#!/bin/bash

ln -i -s $PWD/bin ~/bin
ln -i -s $PWD/.ackrc ~/.ackrc
ln -i -s $PWD/.bashrc ~/.bashrc
ln -i -s $PWD/.bash_aliases ~/.bash_aliases
ln -i -s $PWD/.bash_completions ~/.bash_completions
ln -i -s $PWD/.gitconfig ~/.gitconfig
ln -i -s $PWD/.gitignore_global ~/.gitignore_global
ln -i -s $PWD/.inputrc ~/.inputrc
ln -i -s $PWD/.pryrc ~/.pryrc
ln -i -s $PWD/.psqlrc ~/.psqlrc
ln -i -s $PWD/.mongorc.js ~/.mongorc.js
ln -i -s $PWD/.pythonrc.py ~/.pythonrc.py
ln -i -s $PWD/.vimrc ~/.vimrc
/bin/cp $PWD/.bash_profile ~/.bash_profile

if [[ $(uname) = Darwin ]]; then
  . mac-packages.sh
else
  . linux-packages.sh
fi

# install Powerline font
git clone https://github.com/powerline/fonts ~/Downloads/fonts
pushd ~/Downloads/fonts
./install.sh

# install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
popd

# import iTerm preferences if on MacOS
if [[ $(uname) = Darwin ]]; then
  defaults import com.googlecode.iterm2 iterm2.plist
else
  echo change preferred font in your terminal emulator to "Inconsolata for Powerline"
  echo also, you might want to change the background to '#2C001E rgb(45, 0, 30)'
fi

# once atom is installed, run this:
# apm install apathy-theme color-picker emmet file-icons highlight-selected linter linter-eslint pigments script vim-mode-plus
