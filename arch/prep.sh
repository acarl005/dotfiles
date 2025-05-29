# This script contains setup command to install Arch from the live environment.

# make sure this returns "64". if "efi" subdir doesn't exist, need to boot in EFI mode.
cat /sys/firmware/efi/fw_platform_size

# Set the font. This is good for big display (high DPI)
setfont ter-132b
# This one for smaller displays
setfont ter-m16b

# check for internet
ping archlinux.org

# connect to WIFI if available
iwctl # device list, station wlan0 scan, station wlan0 get-networks, station wlan0 connect "SSID", iwctl station wlan0 show

# update system clock
timedatectl

# get disk path, e.g. /dev/sda
fdisk -l

fdisk /dev/sda # make a boot partition ~260Mb (/dev/sda1) and the rest is the root filesystem (/dev/sda2)

mkfs.ext4 /dev/sda2
mkfs.fat -F 32 /dev/sda1

mount /dev/sda2 /mnt

pacstrap -K /mnt base base-devel linux linux-headers linux-firmware \
  efibootmgr grub os-prober intel-media-driver mesa-utils nvidia-open-dkms nvidia-utils libva-nvidia-driver nvidia-prime bolt \
  bluez bluez-utils networkmanager sof-firmware pipewire pipewire-jack pipewire-alsa alsa-utils pipewire-libcamera libcamera libcamera-ipa rtkit \
  vim sudo git make cmake curl gcc

mount --mkdir /dev/sda1 /mnt/boot/efi

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

# Find your applicable /usr/share/zoneinfo/Region/City
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

# Edit /etc/locale.gen and uncomment "en_US.UTF-8 UTF-8" and other needed UTF-8 locales, e.g. "zh_CN.UTF-8 UTF-8".
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo somehostname > /etc/hostname

passwd

useradd -m -g users -G wheel,storage,video,audio -s /bin/bash andy
passwd andy
# edit /etc/sudoers to uncomment "%wheel ALL=(ALL:ALL) ALL"

grub-install --target x86_64-efi --efi-directory /boot/efi --bootloader-id GRUB
# edit /etc/default/grub, e.g. GRUB_DISABLE_OS_PROBER=false or GRUB_TIMEOUT=30
grub-mkconfig -o /boot/grub/grub.cfg
