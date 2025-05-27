sudo pacman -S libvirt qemu virt-viewer virt-install dnsmasq openbsd-netcat dmidecode edk2-ovmf virglrenderer
sudo usermod -aG libvirt $USER
sudo systemctl start libvirtd.service
sudo systemctl start virtlogd.service

virt-install --name arch --ram 4096 --vcpus 2 --cpu host --disk size=50,format=qcow2 --os-variant archlinux --network user \
  --graphics spice,listen=none,gl.enable=yes,rendernode=/dev/dri/renderD128 \
  --cdrom /var/lib/libvirt/isos/archlinux-2025.05.01-x86_64.iso \
  --console pty,target_type=serial \
  --boot useserial=on,loader=/usr/share/edk2-ovmf/x64/OVMF_CODE.4m.fd,loader.readonly=yes,loader.type=pflash,nvram.template=/usr/share/edk2-ovmf/x64/OVMF_VARS.4m.fd

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
  efibootmgr grub os-prober intel-media-driver nvidia-open-dkms nvidia-utils libva-nvidia-driver nvidia-prime bolt \
  bluez bluez-utils networkmanager sof-firmware pipewire pipewire-jack pipewire-alsa alsa-utils pipewire-libcamera libcamera libcamera-ipa rtkit \
  vim sudo git make cmake curl gcc

mount --mkdir /dev/sda1 /mnt/boot/efi

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

# Edit /etc/locale.gen and uncomment en_US.UTF-8 UTF-8 and other needed UTF-8 locales.
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo somehostname > /etc/hostname

passwd

useradd -m -g users -G wheel,storage,video,audio -s /bin/bash andy
passwd andy

grub-install --target x86_64-efi --efi-directory /boot/efi --bootloader-id GRUB
grub-mkconfig -o /boot/grub/grub.cfg
