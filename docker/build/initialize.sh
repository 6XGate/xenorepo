#!/usr/bin/env bash
set -Eeuox pipefail

# Install the necessary system software.
sudo pacman -Syyu --noconfirm --needed base-devel git yay glow cronie
yay -Y --devel --save

# Setup the build user.
echo "glow /builder/README" >> /builder/.bashrc

# Install the repository.
sudo install -d /var/cache/pacman/xeno -o builder
echo "Include = /etc/pacman.d/xeno" | sudo tee -a /etc/pacman.conf > /dev/null

# Clean-up
sudo pacman -Scc
sudo paccache -rk0
sudo rm -f /var/cache/pacman/pkg/*
