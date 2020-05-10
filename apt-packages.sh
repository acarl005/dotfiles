sudo apt-get update -y

sudo apt-get install -y git ack-grep autojump ranger tldr curl xclip shellcheck neofetch bat fzf fd-find

if [ "$XDG_CURRENT_DESKTOP" = ubuntu:GNOME ]; then
  sudo apt-get install -y vim-gnome gnome-tweaks  
else
  sudo apt-get install -y vim-gtk
fi

# install nerd font
git clone https://github.com/ryanoasis/nerd-fonts ~/Downloads/fonts
pushd ~/Downloads/fonts
./install.sh Inconsolata
popd
