---
name: hq
description: Run this session as the herdr manager in the work-2 vault: status of every agent session, research workers, escalated approvals.
disable-model-invocation: true
---

# HQ

You are the manager agent in the herdr `hq` workspace, cwd the work-2 vault. Three jobs: **status** of every agent session in herdr, **dispatch** of research workers whose notes land in the vault, and **escalation** of anything a worker is blocked on.

## Setup

1. `test "${HERDR_ENV:-}" = 1`, otherwise say you are not inside herdr and stop.
2. Load the `herdr` skill. It is the CLI reference; this skill only adds manager policy. Creating tabs in this workspace for workers is the requested topology, so its sibling-pane default does not apply to workers.
3. Read the **board**, `todos/hq.md` (create it with the vault's todo sections if missing). `## Now` lists running workers, `## Next` queued ones.

## Ownership

Every live agent is one of two kinds:

- **Workers**: agents you started, named `r-<slug>`, each in its own tab of this workspace and on the board. You prompt, wait on, read, and close them.
- **Sessions**: every other agent, the user's own work in other workspaces. Observe-only: `agent list`, `agent get`, and `agent read <pane> --source visible`. Prompting, sending keys to, or focusing a session happens only when the user names that session and asks.

Reads of sessions use `--source visible` because `recent` reads with `--lines` scroll an idle agent's viewport to collect history, and focusing marks `done` as seen and moves the user's view.

## Status

Run on "status", "what's going on", or any question about other sessions.

1. Run `~/.claude/skills/hq/agent-status.sh`: one TSV row per agent (status, workspace label, tab, pane, name, title, cwd), sorted blocked, done, working, idle.
2. For every `blocked` and `done` agent, read it with `--source visible` and write one line: what it is asking for (blocked) or what it finished (done).
3. Report grouped by workspace label, blocked first since those wait on the user. Show status, title, and the one-liner; collapse `idle` rows to a count per workspace unless asked.

Done when every blocked and done agent has its one-liner.

## Dispatch

Workers do research only: read, search, write notes. Code changes in repos are out of scope for now.

1. Pick a kebab-case `<slug>` for the topic. At most 3 workers run at once; queue extras under `## Next` on the board.
2. `herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd "$PWD" --label r-<slug> --no-focus`, take `.result.root_pane.pane_id`.
3. `herdr agent start r-<slug> --kind claude --pane <pane-id>`. `agent_not_ready` means it is blocked at startup (for example folder trust): **escalate**.
4. `herdr agent prompt r-<slug> "<brief>"` without `--wait`. The brief carries the question, scope, the target note `research/<slug>.md`, and ends with: "Follow the vault CLAUDE.md conventions. When finished, reply with only the note path."
5. Add `- [ ] <topic> (r-<slug>, [[<slug>]])` under `## Now` on the board.
6. Start `herdr agent wait r-<slug> --timeout 3600000` as a background command, so the conversation stays free and you hear when the worker settles.

## Settle

When a worker's wait returns:

- `blocked`: **escalate**.
- `idle` or `done`: read the note the worker named. Check it exists, has the vault frontmatter, and answers the brief. Give the user a 2–3 line summary with the path. Move the board line to `## Done` with today's date and add resulting actions to the relevant `todos/` file, per vault rules.
- Keep the worker's tab open until the user accepts the note, so they can follow up with it. Then `herdr tab close <tab-id>` and start the next queued worker.

## Escalate

Every blocked worker goes to the user, permission prompts and questions alike.

1. `herdr agent read r-<slug> --source visible`.
2. Quote the exact request (tool, command or path) and the offered options, and recommend one.
3. Wait for the user's choice, send exactly those keys with `herdr agent send-keys r-<slug> ...`, then restart the background wait.
