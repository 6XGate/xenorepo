#!/usr/bin/env bash
set -Eeuox pipefail
./build.sh
docker compose up -d --pull always --remove-orphans
