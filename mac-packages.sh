if [[ `which brew` ]]; then
  echo Homebrew already installed
else
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install ack autojump git vim coreutils neofetch node
