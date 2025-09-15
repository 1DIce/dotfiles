#!/usr/bin/env bash
# review_since_commit.sh
# Select a commit via fzf, then ask OpenCode CLI to review the combined diffs
# from the selected commit (inclusive) through current HEAD.

set -euo pipefail

# --- prerequisites -----------------------------------------------------------
if ! command -v git >/dev/null 2>&1; then
  echo "Error: git not found in PATH." >&2
  exit 1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Error: not inside a git repository." >&2
  exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
  echo "Error: fzf not found in PATH." >&2
  exit 1
fi

if ! command -v opencode >/dev/null 2>&1; then
  echo "Error: opencode CLI not found in PATH." >&2
  echo "Install docs: https://opencode.ai or via brew install opencode-ai/tap/opencode"
  exit 1
fi

# --- select commit with fzf --------------------------------------------------
# Show commits reachable from HEAD only.
# Preview shows the patch for the commit under the cursor.
selected_line="$(
  git log --color=always \
    --pretty=format:'%C(auto)%h %C(blue)%ad%Creset %s %C(green)(%an)%Creset' \
    --date=short HEAD |
    fzf --ansi --no-sort --reverse --tiebreak=index \
      --prompt="Select starting commit (inclusive): " \
      --height=80% \
      --preview-window=right:60%:wrap \
      --preview 'hash=$(echo {} | awk "{print \$1}"); git show --color=always --stat \"$hash\"'
)"

if [[ -z "${selected_line:-}" ]]; then
  echo "No commit selected. Aborting." >&2
  exit 1
fi

commit="$(echo "$selected_line" | awk '{print $1}')"

# --- validate ancestry -------------------------------------------------------
# If selected commit is not an ancestor of HEAD, fall back to merge-base.
if ! git merge-base --is-ancestor "$commit" HEAD; then
  echo "Warning: selected commit ($commit) is not an ancestor of HEAD." >&2
  mb="$(git merge-base "$commit" HEAD)"
  echo "Using merge-base instead: $mb" >&2
  commit="$mb"
fi

# --- determine base tree to include the selected commit itself ---------------
# We want all changes introduced by the selected commit and everything after it,
# i.e., diff from parent-of-selected .. HEAD. Handle root commit specially.
empty_tree="4b825dc642cb6eb9a060e54bf8d69288fbee4904" # Git's empty tree hash
if git rev-parse -q --verify "${commit}^" >/dev/null 2>&1; then
  base="${commit}^"
else
  base="$empty_tree"
fi

# --- produce combined diff ---------------------------------------------------
# Use --patch to include hunks; consider tuning options to your liking.
# You can add: --find-renames --find-copies --ignore-space-change, etc.
diff_content="$(git diff --patch --no-ext-diff --ignore-space-change "$base" HEAD)"

if [[ -z "$diff_content" ]]; then
  echo "No changes between $commit (inclusive) and HEAD." >&2
  exit 0
fi

# --- run OpenCode review -----------------------------------------------------
# Feed the prompt + diff via stdin to avoid shell arg length limits.
# opencode `run` accepts a one-off prompt message. If your opencode build
# requires an argument, it will still read stdin as the message body.
opencode run << EOF
You are a senior reviewer. Review the following combined git diff, which
covers all changes from the selected starting commit (inclusive) through HEAD.

Please provide:
- Risk assessment (breaking changes, migrations)
- Security considerations
- Performance implications
- Testing impact and gaps
- Style/maintainability issues
- Potential implementation mistakes
- Actionable review checklist

Begin.

--- BEGIN GIT DIFF (from $commit inclusive to HEAD) ---
$diff_content
--- END GIT DIFF ---

EOF
