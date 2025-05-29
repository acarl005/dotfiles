#!/bin/bash

set -e

DIR=$(dirname $(dirname $(readlink -f $0)))

$DIR/install-dotfiles.sh

mkdir -p ~/.config/hypr
ln -fs "$DIR/hypr/hyprland.conf" ~/.config/hypr/hyprland.conf
echo "preload = $DIR/space.jpg" > ~/.config/hypr/hyprpaper.conf
echo "wallpaper = , $DIR/space.jpg" >> ~/.config/hypr/hyprpaper.conf
[ -L ~/.config/waybar ] && rm ~/.config/waybar
ln -s "$DIR/waybar" ~/.config/waybar
[ -L ~/.config/wofi ] && rm ~/.config/wofi
ln -s "$DIR/wofi" ~/.config/wofi

sudo pacman -Syu kitty fish neovim fastfetch man-pages man-db hyprland hyprpaper waybar egl-wayland wl-clipboard \
  swayidle xdg-desktop-portal xdg-desktop-portal-hyprland tmux thunar tumbler firefox htop brightnessctl unzip wofi \
  ripgrep fd fzf tldr bat onefetch jq jless starship rustup git-delta ttf-inconsolata-nerd yazi mpv vlc less \
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

sudo mkdir -p /etc/systemd/logind.conf.d/
sudo cp "$DIR/logind/69-enable-suspend.conf" /etc/systemd/logind.conf.d/

mkdir -p ~/src
cd ~/src
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S autojump

