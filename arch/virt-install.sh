#!/bin/bash
# This script contains commands for creating an Arch installation inside a QEMU VM (assuming an Arch Linux Host).

set -e

sudo pacman -S libvirt qemu virt-viewer virt-install dnsmasq openbsd-netcat dmidecode edk2-ovmf virglrenderer
sudo usermod -aG libvirt $USER
sudo systemctl start libvirtd.service
sudo systemctl start virtlogd.service

# This needs to be one of the DRM devices in $(ls /dev/dri/render*)
# /dev/dri/renderD129 was my Intel iGPU. I tried my Nvidia GPU, but that caused Hyprland to fail to start.
RENDER_NODE=/dev/dri/renderD129
ARCH_ISO_PATH=/var/lib/libvirt/isos/archlinux-2025.05.01-x86_64.iso

virt-install --name arch --ram 4096 --vcpus 2 --cpu host --disk size=50,format=qcow2 --os-variant archlinux --network user \
  --graphics spice,listen=none,gl.enable=yes,rendernode=$RENDER_NODE \
  --cdrom $ARCH_ISO_PATH \
  --console pty,target_type=serial \
  --boot useserial=on,loader=/usr/share/edk2-ovmf/x64/OVMF_CODE.4m.fd,loader.readonly=yes,loader.type=pflash,nvram.template=/usr/share/edk2-ovmf/x64/OVMF_VARS.4m.fd
