#!/usr/bin/env bash
set -eu
if [ $# -ne 1 ]; then
  echo "usage: $0 /path/to/tmux-host-repo" >&2
  exit 2
fi
repo="$1"
dst="$repo/out/task_packets"
mkdir -p "$dst"
cp ./*.json "$dst"/
echo "Copied packets to $dst"
ls -1 "$dst" | sort
