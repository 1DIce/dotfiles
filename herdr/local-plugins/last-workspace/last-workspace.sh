#!/bin/sh
# Tracks workspace focus history and toggles to the previously focused one
# (tmux: switch-client -l).
#
#   track   run on startup and on every workspace.focused event; herdr sets
#           HERDR_WORKSPACE_ID to the newly focused workspace
#   toggle  focus the previous workspace; the resulting workspace.focused event
#           swaps current/previous, so repeated toggles bounce between the two
set -eu

herdr=${HERDR_BIN_PATH:-herdr}
state=${HERDR_PLUGIN_STATE_DIR:?}
current_file=$state/current
previous_file=$state/previous

read_id() { [ -f "$1" ] && cat "$1" || true; }

case "${1:-}" in
track)
  new=${HERDR_WORKSPACE_ID:-}
  [ -n "$new" ] || exit 0
  cur=$(read_id "$current_file")
  [ "$new" = "$cur" ] && exit 0
  [ -n "$cur" ] && printf '%s\n' "$cur" > "$previous_file"
  printf '%s\n' "$new" > "$current_file"
  ;;
toggle)
  prev=$(read_id "$previous_file")
  [ -n "$prev" ] || exit 0
  # previous workspace may have been closed since; drop it
  "$herdr" workspace focus "$prev" >/dev/null 2>&1 || rm -f "$previous_file"
  ;;
*)
  echo "usage: $0 track|toggle" >&2
  exit 2
  ;;
esac
