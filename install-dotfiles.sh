#!/bin/bash

set -e

mkdir -p ~/.warp
mkdir -p ~/.config
mkdir ~/.config/{powershell,fish}

rm -rf ~/.config/nvim
ln -i -s "$PWD/nvim" ~/.config/nvim

if [[ $(uname) = Darwin ]]; then
  [ -L ~/.warp/themes ] && rm ~/.warp/themes
  ln -i -s "$PWD/warp-themes" ~/.warp/themes
else
  [ -L ~/.local/share/warp-terminal/themes ] && rm ~/.local/share/warp-terminal/themes
  ln -i -s "$PWD/warp-themes" ~/.local/share/warp-terminal/themes
fi

ln -fs "$PWD/.ripgreprc" ~/.ripgreprc
ln -fs "$PWD/common-config.sh" ~/common-config.sh
ln -fs "$PWD/config.zsh" ~/config.zsh
ln -fs "$PWD/config.fish" ~/.config/fish
ln -fs "$PWD/Microsoft.PowerShell_profile.ps1" ~/.config/powershell
ln -fs "$PWD/.gitconfig" ~/.gitconfig
ln -fs "$PWD/.gitignore_global" ~/.gitignore_global
ln -fs "$PWD/.inputrc" ~/.inputrc
ln -fs "$PWD/.psqlrc" ~/.psqlrc
ln -fs "$PWD/.pythonrc.py" ~/.pythonrc.py
ln -fs "$PWD/starship.toml" ~/.config/starship.toml
ln -fs "$PWD/.bashrc" ~/.bashrc
command cp -f "$PWD/.zshrc" ~/.zshrc
command cp -f "$PWD/.bash_profile" ~/.bash_profile
