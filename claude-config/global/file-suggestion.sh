#!/bin/bash
QUERY=$(jq -r '.query // ""')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
cd "$PROJECT_DIR" || exit 1
{
  rg --files --follow --hidden . 2>/dev/null
} | sort -u | fzf --filter "$QUERY" | head -15
