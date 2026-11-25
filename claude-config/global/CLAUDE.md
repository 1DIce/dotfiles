- In all interactions and commit messages, be extremely concise and sacrifice grammar for the sake of concision.
- Do not use em-dashes (—) when writing


## Shell

- Prefer `jq` over `python3` for JSON processing in shell commands.

## Security

- Never do process discovery in a loop, network or port scanning, or system discovery sweeps outside the project. My laptop's EDR flags these as MITRE ATT&CK attacks.
- Never run `pkill`, `pgrep`, `killall`, or `ps` pattern searches to find or kill processes. EDR flags them. Only kill a process by a PID you started and recorded yourself (e.g. `$!` or a pid/port file); otherwise ask me to kill it.
- Never use command patterns that EDR could identify as a MITRE ATT&CK technique, even when the intent is harmless. EDR judges behavior, not intent. This includes:
  - `nc`/netcat/socat or raw socket tools, and any process whose stdin/stdout is forwarded over a TCP connection (looks like a reverse shell, e.g. LSP `--client` socket bridges, custom stdio proxies)
  - opening listeners or connecting to ports in ad-hoc tests, port scanning
  - process enumeration (`ps` sweeps, `pgrep`, `pkill -f`, `lsof -i`), loops of discovery commands
  - probing for VM, container or sandbox tools (looks like sandbox evasion)
  - credential/keychain access, persistence (launchd, cron, login items)
  If a task needs one of these, stop and ask me first. Prefer stdio and files over sockets in tests.

## Git

- when creating branches, prefix them with feature/lars/ to indicate that they came from me.

## Plans

- At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise. Sacrifice grammar for the sake of concision.
