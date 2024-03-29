#!/usr/bin/env bash
set -Eeuo pipefail

# Make sure /tmp is writable.
sudo -- chmod u+rwx,g+rwx,o+rwx /tmp

# Setup the xeno repository.
if [ ! -e /var/cache/pacman/xeno/xeno.db.tar.gz ]; then
    echo "::: Creating xeno repository..."
    mkdir -p /var/cache/pacman/xeno
    repo-add /var/cache/pacman/xeno/xeno.db.tar.gz
fi

# Update the repo package set.
echo ": Updating xeno repository..."
pushd /var/cache/pacman/xeno
    repo-add -n xeno.db.tar.gz *.pkg.tar* || true
popd

# Update the system.
echo ": Updating system software..."
sudo -- pacman -Syyu --noconfirm

"$@"
