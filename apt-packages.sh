#!/bin/bash

sudo apt-get update -y

sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:aos1/diff-so-fancy
sudo apt-get update -y
sudo apt-get install --ignore-missing -y git ripgrep autojump tldr curl xclip shellcheck neofetch bat fd-find zsh jq diff-so-fancy

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update \
  && sudo apt install -y gh

sudo snap install onefetch
sudo snap install --classic nvim

# install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  export RUNZSH=no 
  export KEEP_ZSHRC=yes
  export CHSH=yes
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # custom plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  git clone https://github.com/jeffreytse/zsh-vi-mode "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
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
  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts "$HOME/Downloads/fonts"
  pushd ~/Downloads/fonts
  ./install.sh Inconsolata
  popd
fi
