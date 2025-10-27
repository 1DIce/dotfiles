#!/usr/bin/env bash
#simple wrappers around system clipboard managers, like pbcopy on macOS and xclip on Linux
set -e
set -u

if hash pbpaste 2>/dev/null; then
  exec pbpaste
elif hash xclip 2>/dev/null; then
  exec xclip -selection clipboard -o
elif [[ -e /tmp/clipboard ]]; then
  exec cat /tmp/clipboard
else
  echo ''
fi
