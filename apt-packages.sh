sudo apt-get update -y

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# custom plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

sudo apt-get install -y git ack-grep autojump ranger tldr curl xclip shellcheck neofetch bat fzf fd-find zsh

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
