#!/bin/bash

set -e

DIR=$(dirname $(readlink -f $0))

mkdir -p ~/.config/{powershell,fish}

rm -rf ~/.config/nvim
ln -i -s "$DIR/nvim" ~/.config/nvim

if [[ $(uname) = Darwin ]]; then
  mkdir -p ~/.warp
  [ -L ~/.warp/themes ] && rm ~/.warp/themes
  ln -i -s "$DIR/warp-themes" ~/.warp/themes
else
  mkdir -p ~/.local/share/warp-terminal
  [ -L ~/.local/share/warp-terminal/themes ] && rm ~/.local/share/warp-terminal/themes
  ln -i -s "$DIR/warp-themes" ~/.local/share/warp-terminal/themes
fi

[ -L ~/.config/gtk-3.0 ] && rm ~/.config/gtk-3.0
ln -s "$DIR/gtk" ~/.config/gtk-3.0
[ -L ~/.config/gtk-4.0 ] && rm ~/.config/gtk-4.0
ln -s "$DIR/gtk" ~/.config/gtk-4.0
[ -L ~/.config/kitty ] && rm ~/.config/kitty
ln -s "$DIR/kitty" ~/.config/kitty
[ -L ~/.config/ghostty ] && rm ~/.config/ghostty
ln -s "$DIR/ghostty" ~/.config/ghostty

ln -fs "$DIR/.ripgreprc" ~/.ripgreprc
ln -fs "$DIR/common-config.sh" ~/common-config.sh
ln -fs "$DIR/config.zsh" ~/config.zsh
ln -fs "$DIR/config.fish" ~/.config/fish
ln -fs "$DIR/Microsoft.PowerShell_profile.ps1" ~/.config/powershell
ln -fs "$DIR/.gitconfig" ~/.gitconfig
ln -fs "$DIR/.gitignore_global" ~/.gitignore_global
ln -fs "$DIR/.inputrc" ~/.inputrc
ln -fs "$DIR/.psqlrc" ~/.psqlrc
ln -fs "$DIR/.pythonrc.py" ~/.pythonrc.py
ln -fs "$DIR/starship.toml" ~/.config/starship.toml
ln -fs "$DIR/.bashrc" ~/.bashrc
ln -fs "$DIR/.tmux.conf" ~/.tmux.conf
command cp -f "$DIR/.zshrc" ~/.zshrc
command cp -f "$DIR/.bash_profile" ~/.bash_profile
