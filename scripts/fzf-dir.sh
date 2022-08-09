#!/usr/bin/env bash

FD_COMMAND=fd
if ! command -v "$FD_COMMAND" &>/dev/null; then
  FD_COMMAND=fdfind
fi

START_DIR="$1"

if [ -z "$START_DIR" ]; then
  START_DIR=$(pwd)
fi

$FD_COMMAND --base-directory "$START_DIR" --type 'd' --no-ignore --follow --exclude '.git' |
  fzf --preview 'ls -a -d */ {1}'
