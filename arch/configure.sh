#!/bin/bash

set -e

DIR=$(dirname $(dirname $(readlink -f $0)))

$DIR/install-dotfiles.sh

[ -L ~/.config/hypr ] && rm ~/.config/hypr
ln -s "$DIR/hypr" ~/.config/hypr
[ -L ~/.config/waybar ] && rm ~/.config/waybar
ln -s "$DIR/waybar" ~/.config/waybar
[ -L ~/.config/wofi ] && rm ~/.config/wofi
ln -s "$DIR/wofi" ~/.config/wofi
[ -L ~/.config/swaync ] && rm ~/.config/swaync
ln -s "$DIR/swaync" ~/.config/swaync

sudo pacman -Syu kitty fish neovim fastfetch man-pages man-db hyprland hyprpaper hypridle hyprlock hyprcursor waybar egl-wayland wl-clipboard \
  xdg-desktop-portal xdg-desktop-portal-hyprland tmux thunar tumbler firefox htop powertop brightnessctl unzip wofi \
  ripgrep fd fzf tldr bat onefetch jq jless starship rustup git-delta ttf-inconsolata ttf-inconsolata-nerd yazi mpv vlc less \
  adobe-source-han-sans-cn-fonts fcitx5 fcitx5-configtool fcitx5-chinese-addons \
  greetd greetd-tuigreet gnome-themes-extra

chsh -s /bin/fish

rustup default stable
cargo install --locked tree-sitter-cli mdcat

sudo ln -fs /usr/bin/kitty /usr/bin/gnome-terminal

mkdir -p ~/.config/fcitx5/
ln -fs "$DIR/fcitx5.profile" ~/.config/fcitx5/profile

sudo cp "$DIR/greetd-config.toml" /etc/greetd/config.toml
sudo systemctl enable greetd.service

mkdir -p ~/src
cd ~/src
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S autojump bibata-cursor-theme-bin

