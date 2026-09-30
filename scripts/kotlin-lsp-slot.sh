#!/usr/bin/env bash
# Launch kotlin-lsp over stdio with a per-workspace cache slot.
# One process per client (Neovim, Claude Code, ...). kotlin-lsp locks its index
# under --system-path, so concurrent clients on the same workspace each claim
# their own slot. Slots are reused, so after the first index a client starts warm.
#
# Usage:
#   kotlin-lsp-slot.sh [run] [dir]   claim a slot for dir's workspace, exec kotlin-lsp --stdio
#   kotlin-lsp-slot.sh status        list workspaces and their slots
#   kotlin-lsp-slot.sh clean         prune stale locks and caches of deleted workspaces

set -euo pipefail

LSP_BIN="${KOTLIN_LSP_BIN:-kotlin-lsp}"
CACHE_BASE="${KOTLIN_LSP_CACHE:-$HOME/.cache/kotlin-lsp-slots}"
MAX_SLOTS="${KOTLIN_LSP_MAX_SLOTS:-4}"
SETTINGS_MARKERS=(settings.gradle.kts settings.gradle)
BUILD_MARKERS=(build.gradle.kts build.gradle pom.xml)

log() { printf '%s\n' "$*" >&2; }

# Nearest ancestor of $1 containing one of the given markers; non-zero if none.
find_up() {
  local cur="$1" m
  shift
  while [ -n "$cur" ] && [ "$cur" != "/" ]; do
    for m in "$@"; do
      [ -e "$cur/$m" ] && { printf '%s\n' "$cur"; return 0; }
    done
    cur="$(dirname "$cur")"
  done
  return 1
}

# Settings files win so multi-module projects resolve to their top-level root.
resolve_root() {
  local dir
  dir="$(cd "$1" 2>/dev/null && pwd -P)" || dir="$1"
  find_up "$dir" "${SETTINGS_MARKERS[@]}" \
    || find_up "$dir" "${BUILD_MARKERS[@]}" \
    || printf '%s\n' "$dir"
}

workspace_dir() {
  local root="$1" hash
  hash="$(printf '%s' "$root" | shasum | cut -c1-8)"
  printf '%s\n' "$CACHE_BASE/$(basename "$root")-$hash"
}

# Lock = symlink whose target is the owner pid (created atomically by ln -s).
# It is live only if that pid is still a server on this slot (guards pid reuse).
lock_owner() {
  local lock="$1" pid cmd
  pid="$(readlink "$lock" 2>/dev/null)" || return 1
  cmd="$(ps -p "$pid" -o command= 2>/dev/null)" || return 1
  case "$cmd" in
    *" --system-path=${lock%.lock}") printf '%s\n' "$pid" ;;
    *) return 1 ;;
  esac
}

try_claim() {
  ln -s "$$" "$1" 2>/dev/null
}

run() {
  local root ws n slot
  root="$(resolve_root "${1:-${CLAUDE_PROJECT_DIR:-$PWD}}")"
  ws="$(workspace_dir "$root")"
  mkdir -p "$ws"
  printf '%s\n' "$root" >"$ws/root"

  for n in $(seq 1 "$MAX_SLOTS"); do
    slot="$ws/slot-$n"
    if try_claim "$slot.lock"; then
      exec "$LSP_BIN" --stdio --system-path="$slot"
    fi
    lock_owner "$slot.lock" >/dev/null && continue
    # Stale: reclaim once; if a concurrent client wins the ln, move on.
    rm -f "$slot.lock"
    if try_claim "$slot.lock"; then
      exec "$LSP_BIN" --stdio --system-path="$slot"
    fi
  done

  log "kotlin-lsp: all $MAX_SLOTS slots for $root in use (KOTLIN_LSP_MAX_SLOTS)"
  exit 1
}

status() {
  local ws slot lock pid state found=0
  for ws in "$CACHE_BASE"/*/; do
    [ -d "$ws" ] || continue
    found=1
    ws="${ws%/}"
    log "$(cat "$ws/root" 2>/dev/null || basename "$ws")"
    for slot in "$ws"/slot-*; do
      case "$slot" in *.lock) continue ;; esac
      [ -d "$slot" ] || continue
      lock="$slot.lock"
      if pid="$(lock_owner "$lock")"; then
        state="live pid=$pid"
      elif [ -L "$lock" ]; then
        state="stale"
      else
        state="free"
      fi
      log "  $(basename "$slot")  $(printf '%-16s' "$state") $(du -sh "$slot" 2>/dev/null | cut -f1)"
    done
  done
  [ "$found" -eq 1 ] || log "no kotlin-lsp workspaces under $CACHE_BASE"
}

clean() {
  local ws lock root live
  for ws in "$CACHE_BASE"/*/; do
    [ -d "$ws" ] || continue
    ws="${ws%/}"
    root="$(cat "$ws/root" 2>/dev/null || true)"
    live=0
    for lock in "$ws"/slot-*.lock; do
      [ -L "$lock" ] || continue
      if lock_owner "$lock" >/dev/null; then
        live=1
      else
        rm -f "$lock" && log "removed stale lock $lock"
      fi
    done
    if [ "$live" -eq 0 ] && { [ -z "$root" ] || [ ! -d "$root" ]; }; then
      rm -rf "$ws" && log "removed $ws (workspace ${root:-unknown} gone)"
    fi
  done
}

cmd="${1:-run}"
case "$cmd" in
  run)    shift || true; run "${1:-}" ;;
  status) status ;;
  clean)  clean ;;
  *)      run "$cmd" ;; # bare dir argument
esac
