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
[ -L ~/.config/swayosd ] && rm ~/.config/swayosd
ln -s "$DIR/swayosd" ~/.config/swayosd
[ -L ~/.config/fastfetch ] && rm ~/.config/fastfetch
ln -s "$DIR/fastfetch" ~/.config/fastfetch
[ -L ~/.config/xdg-desktop-portal ] && rm ~/.config/xdg-desktop-portal
ln -s "$DIR/xdg-desktop-portal" ~/.config/xdg-desktop-portal
[ -L ~/.config/gtk-3.0 ] && rm ~/.config/gtk-3.0
ln -s "$DIR/gtk" ~/.config/gtk-3.0
[ -L ~/.config/gtk-4.0 ] && rm ~/.config/gtk-4.0
ln -s "$DIR/gtk" ~/.config/gtk-4.0
[ -L ~/.config/qt5ct ] && rm ~/.config/qt5ct
ln -s "$DIR/qt" ~/.config/qt5ct
[ -L ~/.config/qt6ct ] && rm ~/.config/qt6ct
ln -s "$DIR/qt" ~/.config/qt6ct
[ -L ~/.config/quickshell ] && rm ~/.config/quickshell
ln -s "$DIR/quickshell" ~/.config/quickshell
[ -L ~/.config/nwg-dock-hyprland ] && rm ~/.config/nwg-dock-hyprland
ln -s "$DIR/nwg-dock-hyprland" ~/.config/nwg-dock-hyprland

mkdir -p ~/.local/share/applications
ln -fs "$DIR/applications/nvim.desktop" ~/.local/share/applications/nvim.desktop

sudo pacman -Syu kitty ghostty fish neovim man-pages man-db hyprland hyprpm hyprpaper hypridle hyprlock hyprcursor hyprpolkitagent waybar egl-wayland wl-clipboard \
  nwg-dock-hyprland xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk tmux thunar tumbler firefox htop powertop unzip wofi \
  eza ripgrep fd fzf tldr bat onefetch jq jless starship rustup git-delta ttf-inconsolata ttf-inconsolata-nerd yazi mpv vlc vlc-plugin-ffmpeg less \
  fastfetch greetd uwsm gnome-themes-extra swaync swayosd gvfs grim slurp blueman wiremix resvg socat python-pipx wf-recorder \
  noto-fonts-emoji adobe-source-han-sans-cn-fonts fcitx5 fcitx5-configtool fcitx5-chinese-addons keyd quickshell qt5ct qt6ct gnome-keyring libsecret

# Prevent hyprpolkitagent from hitting start-limit-hit when the Wayland socket closes on logout
mkdir -p ~/.config/systemd/user/hyprpolkitagent.service.d
printf "[Unit]\nStartLimitIntervalSec=0\n\n[Service]\nRestartSec=2\n" > ~/.config/systemd/user/hyprpolkitagent.service.d/override.conf
systemctl --user daemon-reload
systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now gnome-keyring-daemon.socket

# Auto-unlock gnome-keyring at login via greetd PAM
if ! grep -q "pam_gnome_keyring.so" /etc/pam.d/greetd; then
  sudo sh -c 'printf "\nauth       optional     pam_gnome_keyring.so\nsession    optional     pam_gnome_keyring.so auto_start\n" >> /etc/pam.d/greetd'
fi

sudo mkdir -p /etc/keyd
sudo ln -fs "$DIR/keyd/default.conf" /etc/keyd/default.conf
sudo systemctl enable --now keyd

chsh -s /bin/fish
xdg-mime default nvim.desktop text/plain
xdg-mime default thunar.desktop inode/directory

rustup default stable
cargo install --locked mdcat rusty-rain
# rusty-rain -s -g classic

# Unfortunate hack that is necessary for opening `.desktop` files where `Terminal=true`.
sudo ln -fs /usr/bin/ghostty /usr/bin/gnome-terminal

mkdir -p ~/.config/fcitx5/
ln -fs "$DIR/fcitx5.profile" ~/.config/fcitx5/profile

sudo cp "$DIR/grub/space.jpg" /boot/grub
sudo grub-mkfont -s 32 -o /boot/grub/fonts/Inconsolata32.pf2 /usr/share/fonts/TTF/Inconsolata-Regular.ttf
sudo sh -c 'echo GRUB_BACKGROUND="/boot/grub/space.jpg" >> /etc/default/grub'
sudo sh -c 'echo GRUB_FONT="/boot/grub/fonts/Inconsolata32.pf2" >> /etc/default/grub'
sudo grub-mkconfig -o /boot/grub/grub.cfg

if [ -d /sys/class/backlight/intel_backlight ] &&
   strings /sys/class/backlight/intel_backlight/device/edid 2>/dev/null | grep -q '^ATNA' &&
   ! grep -q 'i915.enable_dpcd_backlight=1' /etc/default/grub; then
  echo "NOTE: Samsung OLED panel detected on intel_backlight. Add 'i915.enable_dpcd_backlight=1' to GRUB_CMDLINE_LINUX_DEFAULT in /etc/default/grub and re-run grub-mkconfig."
fi

sudo systemctl enable --now blueman-mechanism.service
sudo systemctl enable --now bluetooth
sudo systemctl enable --now swayosd-libinput-backend.service

# I prefer to have systemd-resolved, rather than NetworkManager, handle hostnames since it supports mDNS out of the box.
sudo systemctl enable --now systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo sh -c 'echo MulticastDNS=yes >> /etc/systemd/resolved.conf'
sudo sh -c 'echo LLMNR=no >> /etc/systemd/resolved.conf'
sudo sh -c 'echo DNSStubListener=yes >> /etc/systemd/resolved.conf'
sudo systemctl restart systemd-resolved

hyprpm update
hyprpm add https://github.com/gfhdhytghd/hymission
hyprpm enable hymission
hyprpm reload

mkdir -p ~/src
cd ~/src
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S autojump bibata-cursor-theme-bin sysc-greet-hyprland adwaita-colors-icon-theme pipes-rs lavat-git
# lavat -g -c ff5ea0 -k bd5eff
# pipes-rs -p 8 -c ansi

sudo mkdir -p /usr/share/sysc-greet/themes
sudo cp -f "$DIR/sysc-greet/themes/cyberdream.toml" /usr/share/sysc-greet/themes/cyberdream.toml

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Adwaita-pink'
