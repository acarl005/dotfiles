#!/bin/bash

sudo apt-get update -y

sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:aos1/diff-so-fancy
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt-get update -y
sudo apt-get install --ignore-missing -y git ripgrep autojump tldr curl xclip shellcheck fastfetch bat fd-find fzf fish jq diff-so-fancy build-essential ffmpeg

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update \
  && sudo apt install -y gh

chsh -s /bin/fish

sudo snap install onefetch
sudo snap install --classic nvim

# install starship
if ! command -v starship >/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

~/.cargo/bin/cargo install --locked tree-sitter-cli yazi-fm yazi-cli git-delta

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

readarray -t ASSETS < <(curl -s https://api.github.com/repos/acarl005/ls-go/releases/latest | jq -r '.assets[].browser_download_url')

PS3='Select a bin to install: '
select ASSET in "${ASSETS[@]}"
do
  echo $ASSET
  curl -LO $ASSET
  chmod +x ls-go-*
  mkdir -p ~/.local/bin
  mv ls-go-* ~/.local/bin/ls-go
  break
done

if [ $INSTALL_FONTS -eq 1 ]; then
  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts "$HOME/Downloads/fonts"
  pushd ~/Downloads/fonts
  ./install.sh Inconsolata
  popd
fi
