if command -v brew >/dev/null; then
  echo Homebrew already installed
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)" 
fi

# install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  mv -f ~/.zshrc.pre-oh-my-zsh ~/.zshrc

  # custom plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi


brew tap homebrew/cask-fonts
brew install ripgrep autojump git vim neovim coreutils neofetch ranger fd tldr shellcheck bat fzf onefetch highlight mdcat jq starship diff-so-fancy
brew install --cask font-inconsolata-nerd-font
brew install acarl005/homebrew-formulas/ls-go

$(brew --prefix)/opt/fzf/install
