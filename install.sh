ln -s $PWD/bin ~/bin
ln -s $PWD/.bashrc ~/.bashrc
ls -s $PWD/.bash_aliases ~/.bash_aliases
ls -s $PWD/.bash_completions ~/.bash_completions
ls -s $PWD/.gitconfig ~/.gitconfig
ls -s $PWD/.gitignore_global ~/.gitignore_global
ls -s $PWD/.inputrc ~/.inputrc
ls -s $PWD/.pryrc ~/.pryrc
ls -s $PWD/.psqlrc ~/.psqlrc
ls -s $PWD/.mongorc.js ~/.mongorc.js
ls -s $PWD/.pythonrc.py ~/.pythonrc.py
ls -s $PWD/.vimrc ~/.vimrc

if [[ $(uname) = Darwin ]]; then
  . mac-packages.sh
else
  . linux-packages.sh
fi

# install more most up-to-date git and vim
git clone https://github.com/powerline/fonts ~/Downloads/fonts
cd !$
./install.sh
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

if [[ $(uname) = Darwin ]]; then
  defaults import com.googlecode.iterm2 iterm2.plist
else
  echo change preferred font in your terminal emulator to "Inconsolata for Powerline"
  echo also, you might want to change the background to '#2C001E rgb(45, 0, 30)'
fi

# once atom is installed, run this:
# apm install apathy-theme color-picker emmet file-icons highlight-selected linter linter-eslint pigments script vim-mode-plus
