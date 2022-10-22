#!/bin/bash

sudo dnf update -y
sudo dnf install -y 'dnf-command(copr)'
sudo dnf install -y which man git neovim python3-neovim ripgrep autojump ranger tldr xclip neofetch bat fzf fd-find zsh jq tmux

# TODO - enable when this is fixed
# https://github.com/o2sh/onefetch/issues/830
#sudo dnf copr enable -y varlad/onefetch
#sudo dnf install -y onefetch 

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/src"
git clone https://github.com/so-fancy/diff-so-fancy.git "$HOME/src/diff-so-fancy"
ln -s "$HOME/src/diff-so-fancy/diff-so-fancy" "$HOME/.local/bin"

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
