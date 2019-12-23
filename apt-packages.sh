HAS_GUI=$1

sudo apt-get update

sudo apt-get install -y git vim-gnome ack-grep autojump ranger tldr curl xclip shellcheck neofetch
# enable once ubuntu 20.04 comes out
# sudo apt-get install -y bat fzf fd-find

if [ "$HAS_GUI" = true ]; then
  sudo apt-get install -y gnome-tweaks guake
fi

