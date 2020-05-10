mkdir ~/.vim

ln -i -s $PWD/bin ~/bin
ln -i -s $PWD/ftplugin ~/.vim/ftplugin
ln -i -s $PWD/indent ~/.vim/indent
ln -i -s $PWD/.ackrc ~/.ackrc
ln -i -s $PWD/common-config.sh ~/common-config.sh
ln -i -s $PWD/config.bash ~/config.bash
ln -i -s $PWD/.bash_aliases ~/.bash_aliases
ln -i -s $PWD/.bash_completions ~/.bash_completions
ln -i -s $PWD/.gitconfig ~/.gitconfig
ln -i -s $PWD/.gitignore_global ~/.gitignore_global
ln -i -s $PWD/.inputrc ~/.inputrc
ln -i -s $PWD/.pryrc ~/.pryrc
ln -i -s $PWD/.psqlrc ~/.psqlrc
ln -i -s $PWD/.mongorc.js ~/.mongorc.js
ln -i -s $PWD/.pythonrc.py ~/.pythonrc.py
ln -i -s $PWD/.condarc ~/.condarc
ln -i -s $PWD/.vimrc ~/.vimrc
ln -i -s $PWD/.zshrc ~/.zshrc
/bin/cp $PWD/.bashrc ~/.bashrc
/bin/cp $PWD/.bash_profile ~/.bash_profile
