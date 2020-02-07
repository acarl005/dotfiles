#!/bin/bash

HAS_GUI=true
USE_SUDO=true

while [[ "$#" > 0 ]]; do
  case $1 in
    --no-gui) HAS_GUI=false;;
    --no-sudo) USE_SUDO=false;;
    *) echo "Unknown parameter passed: $1"; exit 1;;
  esac
  shift
done

mkdir ~/.vim

ln -i -s $PWD/bin ~/bin
ln -i -s $PWD/ftplugin ~/.vim/ftplugin
ln -i -s $PWD/indent ~/.vim/indent
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

if [ "$USE_SUDO" = true ]; then
  if [[ $(uname) = Darwin ]]; then
    . mac-packages.sh
  elif command -v apt-get >/dev/null; then
    . apt-packages.sh "$HAS_GUI"
  elif command -v yum >/dev/null; then
    . yum-packages.sh
  else
    echo no known package manager installed
  fi
fi

if [ "$HAS_GUI" = true ]; then
  # install nerd font
  git clone https://github.com/ryanoasis/nerd-fonts ~/Downloads/fonts
  pushd ~/Downloads/fonts
  ./install.sh Inconsolata
  popd
fi

git_completion_script=/usr/local/etc/bash_completion.d/git-completion.bash
git_prompt_script=/usr/local/etc/bash_completion.d/git-prompt.sh
if ! test -s $git_completion_script; then
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/git-completion.bash
fi
if ! test -s $git_prompt_script; then
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ~/git-prompt.sh
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
  # install nvidia drivers https://www.linuxbabe.com/ubuntu/install-nvidia-driver-ubuntu-18-04
  # enable Night Light https://vitux.com/how-to-activate-night-light-on-ubuntu-desktop/
  # use Tweaks to: dark theme, startup Guake
fi
