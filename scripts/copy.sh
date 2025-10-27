#!/usr/bin/env bash
# simple wrappers around system clipboard managers, like pbcopy on macOS and xclip on Linux
set -e
set -u

if hash pbcopy 2>/dev/null; then
  exec pbcopy
elif hash xclip 2>/dev/null; then
  exec xclip -selection clipboard
elif hash putclip 2>/dev/null; then
  exec putclip
else
  rm -f /tmp/clipboard 2> /dev/null
  if [ $# -eq 0 ]; then
    cat > /tmp/clipboard
  else
    cat "$1" > /tmp/clipboard
  fi
fi
