if [[ `which brew` ]]; then
  echo Homebrew already installed
else
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap caskroom/fonts
brew install ack autojump git vim coreutils neofetch node
brew cask install font-inconsolata-nerd-font
