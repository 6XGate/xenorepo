#!/usr/bin/env bash
set -Eeuox pipefail
./build.sh
docker run --ulimit "nofile=1024:10240" -it --rm \
	--tmpfs /tmp:exec --tmpfs /run --tmpfs /run/lock \
	--name xenorepo xenorepo bash
