#!/bin/bash


# set preferred keyboard sensitivity settings
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# autohide the dock
defaults write com.apple.dock autohide -int 1

if command -v brew >/dev/null; then
  echo Homebrew already installed
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)" 
  echo 'eval $(/opt/homebrew/bin/brew shellenv)' | cat - .zshrc > ~/.zshrc
fi

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


brew install ripgrep autojump git gh neovim coreutils fastfetch fd tldr shellcheck bat onefetch highlight mdcat jq starship tree-sitter diff-so-fancy git-delta font-inconsolata-nerd-font
brew install acarl005/homebrew-formulas/ls-go
