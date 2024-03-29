#!/bin/bash

set -e

. ./install-dotfiles.sh

if [[ $(uname) = Darwin ]]; then
  . mac-packages.sh
elif command -v apt-get >/dev/null; then
  . apt-packages.sh
elif command -v dnf >/dev/null; then
  . dnf-packages.sh
else
  echo no known package manager installed
fi

# import iTerm preferences if on MacOS
if [[ $(uname) = Darwin ]]; then
  defaults import com.googlecode.iterm2 iterm2.plist
fi

echo change preferred font in your terminal emulator to "Inconsolata Nerd Font" or similar
