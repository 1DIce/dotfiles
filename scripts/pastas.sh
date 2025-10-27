#!/usr/bin/env bash
# pastas prints the current state of your clipboard to stdout,
# and then whenever the clipboard changes, it prints the new version.
set -e
set -u
set -o pipefail

trap 'exit 0' SIGINT

last_value=''

while true
do
  value="$(pasta)"

  if [ "$last_value" != "$value" ]; then
    echo "$value"
    last_value="$value"
  fi

  sleep 0.1
done
