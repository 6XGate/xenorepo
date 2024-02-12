#!/usr/bin/env bash
set -Eeuo pipefail

# Update the system.
echo ": Updating system and AUR packages..."
xeno update
