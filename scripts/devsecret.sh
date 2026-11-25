#!/usr/bin/env bash
# Dev secrets in a separate macOS keychain. Reading a secret asks for Touch ID once
# per terminal session and secret, then again after 1h.
#
#   devsecret init         create the keychain and build the helper
#   devsecret set <name>   store or replace a secret (prompts, or reads stdin when piped)
#   devsecret get <name>   print a secret to stdout (Touch ID unless granted)
#   devsecret get --json <name>...
#                          print secrets as a JSON object (one Touch ID for all ungranted)
#   devsecret list         print the names of all stored secrets
#   devsecret lock         forget the Touch ID grants of this terminal session
set -e
set -u

SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
KEYCHAIN="$HOME/Library/Keychains/dev-secrets.keychain-db"
HELPER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/devsecret"
HELPER="$HELPER_DIR/devsecret-helper"
SOURCE="$(dirname "$SCRIPT")/devsecret-helper.swift"

usage() {
  sed -n '2,11s/^# \{0,1\}//p' "$SCRIPT" >&2
  exit 2
}

build_helper() {
  mkdir -p "$HELPER_DIR"
  swiftc -O -suppress-warnings "$SOURCE" -o "$HELPER"
  echo "Built helper: $HELPER" >&2
}

require_init() {
  if [[ ! -f "$KEYCHAIN" ]]; then
    echo "devsecret: not initialized, run 'devsecret init'" >&2
    exit 1
  fi
  # A rebuilt helper has a new code signature, so each secret asks once to allow it again.
  if [[ ! -x "$HELPER" || "$SOURCE" -nt "$HELPER" ]]; then
    build_helper
  fi
}

cmd_init() {
  if [[ -f "$KEYCHAIN" ]]; then
    echo "Keychain exists: $KEYCHAIN"
  else
    echo "Creating keychain $KEYCHAIN (choose a password for it)"
    security create-keychain "$KEYCHAIN"
    security set-keychain-settings -l -u -t 3600 "$KEYCHAIN"
  fi
  build_helper
}

cmd_set() {
  local name="$1" value
  require_init
  if [[ -t 0 ]]; then
    read -rsp "Value for $name: " value
    echo >&2
    printf '%s' "$value" | "$HELPER" set "$KEYCHAIN" "$name"
  else
    "$HELPER" set "$KEYCHAIN" "$name"
  fi
}

cmd_get() {
  require_init
  exec "$HELPER" get "$KEYCHAIN" "$1"
}

cmd_get_json() {
  require_init
  exec "$HELPER" getjson "$KEYCHAIN" "$@"
}

cmd_list() {
  require_init
  exec "$HELPER" list "$KEYCHAIN"
}

cmd_lock() {
  require_init
  exec "$HELPER" lock
}

[[ $# -ge 1 ]] || usage
case "$1" in
  init) cmd_init ;;
  set) [[ $# -eq 2 ]] || usage; cmd_set "$2" ;;
  get)
    if [[ $# -ge 2 && "$2" == --json ]]; then
      [[ $# -ge 3 ]] || usage
      shift 2
      cmd_get_json "$@"
    else
      [[ $# -eq 2 ]] || usage
      cmd_get "$2"
    fi
    ;;
  list) [[ $# -eq 1 ]] || usage; cmd_list ;;
  lock) [[ $# -eq 1 ]] || usage; cmd_lock ;;
  *) usage ;;
esac
