#!/bin/bash

sudo apt-get update -y

sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:aos1/diff-so-fancy
sudo add-apt-repository -y ppa:neovim-ppa/stable
sudo add-apt-repository -y ppa:o2sh/onefetch
sudo apt-get update -y
sudo apt-get install --ignore-missing -y git ripgrep autojump ranger tldr curl xclip shellcheck neofetch bat fzf fd-find zsh neovim jq diff-so-fancy onefetch

if [ "$XDG_CURRENT_DESKTOP" = ubuntu:GNOME ]; then
  sudo apt-get install -y vim-gnome gnome-tweaks  
else
  sudo apt-get install -y vim-gtk
fi

# install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
  export RUNZSH=no 
  export KEEP_ZSHRC=yes
  export CHSH=yes
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # custom plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

# install starship
if ! command -v starship >/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# install nerd font
while true; do
  read -rp "Do you want to install nerd fonts? (Y/n): " yn
  case $yn in
    [Yy]* ) INSTALL_FONTS=1; break;;
    [Nn]* ) INSTALL_FONTS=0; break;;
    '' ) INSTALL_FONTS=1; break;;
    * ) echo "Please answer y or n";;
  esac
done

if [ $INSTALL_FONTS -eq 1 ]; then
  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts ~/Downloads/fonts
  pushd ~/Downloads/fonts
  ./install.sh Inconsolata BitstreamVeraSansMono
  popd
fi
