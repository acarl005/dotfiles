if command -v brew >/dev/null; then
  echo Homebrew already installed
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# custom plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

brew tap homebrew/cask-fonts
brew install ripgrep autojump git vim neovim coreutils neofetch ranger fd tldr shellcheck bat fzf onefetch highlight mdcat jq bash-completion starship
brew install --cask font-inconsolata-nerd-font
brew install acarl005/homebrew-formulas/ls-go

$(brew --prefix)/opt/fzf/install
