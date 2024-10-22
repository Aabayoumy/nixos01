#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
    # If not, re-execute the script with sudo
    echo "This script requires root privileges. Elevating..."
    sudo bash "$0" "$@"
    exit $?
fi

# Check if the envsubst is installed
if ! nix-env -q envsubst >/dev/null 2>&1; then
    nix-env -iA nixos.envsubst
fi

DEVICE="/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0"
if [ ! -b "$DEVICE" ]; then
    echo "ERROR: The default disk $DEVICE is missing!"
    exit 1;
fi

# List partitions on the device
PARTITIONS=$(lsblk "$DEVICE" --output NAME --noheadings --raw | wc -l)

parted $DEVICE -- mklabel gpt
parted $DEVICE -- mkpart root ext4 512MB 100%
parted $DEVICE -- mkpart ESP fat32 1MB 512MB
parted $DEVICE -- set 2 esp on
sync
mkfs.ext4 -L nixos $DEVICE-part1
mkfs.fat -F 32 -n boot  $DEVICE-part2 
sync
mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot


nixos-generate-config --root /mnt


FLAKE="github:Aabayoumy/nixos01#nixos01"
sudo nixos-install --flake "$FLAKE"

while true; do
    read -p "Do you want to reboot now? (y/n) " yn
    case $yn in
        [Yy]* )
            reboot
            break;;
        [Nn]* )
            exit;;
        * )
            echo "Please answer y or n.";;
    esac
done
