HAS_GUI=$1

sudo apt-get update

sudo apt-get install -y git ack-grep autojump ranger tldr curl xclip shellcheck neofetch
# enable once ubuntu 20.04 comes out
# sudo apt-get install -y bat fzf fd-find

if [ "$XDG_CURRENT_DESKTOP" = ubuntu:GNOME ]; then
  sudo apt-get install -y vim-gnome 
else
  sudo apt-get install -y vim-gtk
fi

if [ "$HAS_GUI" = true ]; then
  sudo apt-get install -y guake
  if [ "$XDG_CURRENT_DESKTOP" = ubuntu:GNOME ]; then
    sudo apt-get install -y gnome-tweaks  
  else
    sudo apt-get install -y unity-tweak-tool
  fi
fi

