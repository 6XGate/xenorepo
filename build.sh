#!/usr/bin/env bash
set -Eeuox pipefail

docker build --ulimit nofile=1024:10240 -t xenorepo:latest .
if [ -x ./local-build.sh ]; then
	./local-build.sh
fi
