#!/bin/sh
# One TSV row per live herdr agent:
# status  workspace-label  tab  pane  name  title  cwd
set -eu
herdr agent list > "${TMPDIR:-/tmp}/hq-agents.json"
herdr workspace list | jq --slurpfile a "${TMPDIR:-/tmp}/hq-agents.json" -r '
  (.result.workspaces | map({(.workspace_id): .label}) | add) as $ws
  | $a[0].result.agents
  | sort_by(.agent_status != "blocked", .agent_status != "done", .agent_status != "working")
  | .[]
  | [.agent_status, $ws[.workspace_id], .tab_id, .pane_id, (.name // "-"),
     (.terminal_title_stripped // "-"), .cwd]
  | @tsv'
