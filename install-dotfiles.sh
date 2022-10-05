mkdir ~/.vim
mkdir ~/.config
mkdir ~/.config/nvim
mkdir ~/.config/ranger

[ -L ~/bin ] && rm ~/bin
ln -i -s "$PWD/bin" ~/bin
[ -L ~/.vim/ftplugin ] && rm ~/.vim/ftplugin
ln -i -s "$PWD/ftplugin" ~/.vim/ftplugin
[ -L ~/.vim/indent ] && rm ~/.vim/indent
ln -i -s "$PWD/indent" ~/.vim/indent
[ -L ~/.config/nvim/ftplugin ] && rm ~/.config/nvim/ftplugin
ln -i -s "$PWD/ftplugin" ~/.config/nvim/ftplugin

ln -i -s "$PWD/.ackrc" ~/.ackrc
ln -i -s "$PWD/.ripgreprc" ~/.ripgreprc
ln -i -s "$PWD/common-config.sh" ~/common-config.sh
ln -i -s "$PWD/config.bash" ~/config.bash
ln -i -s "$PWD/config.zsh" ~/config.zsh
ln -i -s "$PWD/.bash_completions" ~/.bash_completions
ln -i -s "$PWD/.gitconfig" ~/.gitconfig
ln -i -s "$PWD/.gitignore_global" ~/.gitignore_global
ln -i -s "$PWD/.inputrc" ~/.inputrc
ln -i -s "$PWD/.pryrc" ~/.pryrc
ln -i -s "$PWD/.psqlrc" ~/.psqlrc
ln -i -s "$PWD/.mongorc.js" ~/.mongorc.js
ln -i -s "$PWD/.pythonrc.py" ~/.pythonrc.py
ln -i -s "$PWD/.condarc" ~/.condarc
ln -i -s "$PWD/.vimrc" ~/.vimrc
ln -i -s "$PWD/init.lua" ~/.config/nvim/init.lua
ln -i -s "$PWD/rc.conf" ~/.config/ranger/rc.conf
ln -i -s "$PWD/scope.sh" ~/.config/ranger/scope.sh
/bin/cp "$PWD/.zshrc" ~/.zshrc
/bin/cp "$PWD/.bashrc" ~/.bashrc
/bin/cp "$PWD/.bash_profile" ~/.bash_profile
