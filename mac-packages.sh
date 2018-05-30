if [[ `which brew` ]]; then
  echo Homebrew already installed
else
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap caskroom/fonts
brew install ack autojump git vim coreutils neofetch bash ranger fd
brew cask install font-inconsolata-nerd-font

# tell it to use the new installed version of bash
chsh -s /usr/local/bin/bash

