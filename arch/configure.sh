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
[ -L ~/.config/fastfetch ] && rm ~/.config/fastfetch
ln -s "$DIR/fastfetch" ~/.config/fastfetch
[ -L ~/.config/xdg-desktop-portal ] && rm ~/.config/xdg-desktop-portal
ln -s "$DIR/xdg-desktop-portal" ~/.config/xdg-desktop-portal

sudo pacman -Syu kitty ghostty fish neovim man-pages man-db hyprland hyprpaper hypridle hyprlock hyprcursor waybar egl-wayland wl-clipboard \
  xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk tmux thunar tumbler firefox htop powertop brightnessctl unzip wofi \
  eza ripgrep fd fzf tldr bat onefetch jq jless starship rustup git-delta ttf-inconsolata ttf-inconsolata-nerd yazi mpv vlc vlc-plugin-ffmpeg less \
  neovide fastfetch greetd greetd-tuigreet gnome-themes-extra swaync gvfs grim slurp blueman resvg socat \
  adobe-source-han-sans-cn-fonts fcitx5 fcitx5-configtool fcitx5-chinese-addons

chsh -s /bin/fish
xdg-mime default neovide.desktop text/plain
xdg-mime default thunar.desktop inode/directory

rustup default stable
cargo install --locked tree-sitter-cli mdcat

# Unfortunate hack that is necesssary for opening `.desktop` files where `Terminal=true`.
sudo ln -fs /usr/bin/ghotty /usr/bin/gnome-terminal

mkdir -p ~/.config/fcitx5/
ln -fs "$DIR/fcitx5.profile" ~/.config/fcitx5/profile

sudo cp "$DIR/greetd-config.toml" /etc/greetd/config.toml
sudo systemctl enable greetd.service

sudo cp "$DIR/grub/space.jpg" /boot/grub
sudo grub-mkfont -s 32 -o /boot/grub/fonts/Inconsolata32.pf2 /usr/share/fonts/TTF/Inconsolata-Regular.ttf
sudo sh -c 'echo GRUB_BACKGROUND="/boot/grub/space.jpg" >> /etc/default/grub'
sudo sh -c 'echo GRUB_FONT="/boot/grub/fonts/Inconsolata32.pf2" >> /etc/default/grub'
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo systemctl enable --now blueman-mechanism.service

# I prefer to have systemd-resolved, rather than NetworkManager, handle hostnames since it supports mDNS out of the box.
sudo systemctl enable --now systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo sh -c 'echo MulticastDNS=yes >> /etc/systemd/resolved.conf'
sudo sh -c 'echo LLMNR=no >> /etc/systemd/resolved.conf'
sudo sh -c 'echo DNSStubListener=yes >> /etc/systemd/resolved.conf'
sudo systemctl restart systemd-resolved

mkdir -p ~/src
cd ~/src
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S autojump bibata-cursor-theme-bin

