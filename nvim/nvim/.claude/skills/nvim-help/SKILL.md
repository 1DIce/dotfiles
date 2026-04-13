---
name: nvim-help
description: Look up Neovim's built-in help documentation to answer implementation questions. Use this skill whenever the user asks how to implement anything in Neovim — keymaps, autocmds, LSP config, Lua API calls, vim options, filetype plugins, diagnostics, user commands, or anything else Neovim-related. Even if you think you know the answer — Neovim's Lua API evolves between versions, and the installed help files reflect the exact version the user is running. Prefer this over relying on training data for any Neovim implementation question.
allowed-tools:
  - Grep
  - Read
---

# Neovim Help Lookup

When asked how to implement something in Neovim, consult the actual help files rather than relying on training knowledge. Neovim's API changes between versions — the installed docs are authoritative.

## Workflow

1. **Identify the topic** — what API, option, function, or feature does the user need?
2. **Search help files** — find relevant sections using Grep
3. **Read the content** — use Read to get the full section
4. **Answer with evidence** — cite exact signatures and examples from the help text

## Searching

### Built-in docs

Search for a function or keyword:
```
Grep: pattern="vim\.keymap\.set" path="/usr/share/nvim/runtime/doc/"
```

Find which file defines a specific tag:
```
Grep: pattern="\*vim\.keymap\.set\*" path="/usr/share/nvim/runtime/doc/"
```

Search with context:
```
Grep: pattern="nvim_create_autocmd" path="/usr/share/nvim/runtime/doc/api.txt" output_mode="content" context=10
```

### Plugin docs

```
Grep: pattern="sources" path="~/.local/share/nvim/lazy/blink.cmp/doc/"
Grep: pattern="pattern" path="~/.local/share/nvim/lazy/" glob="*/doc/*.txt"
```

### Read a full help file

```
Read: ~/.local/share/nvim/runtime/doc/lsp.txt
```

## Key Help Files

| Topic | File |
|-------|------|
| Lua guide (practical) | `/usr/share/nvim/runtime/doc/lua-guide.txt` |
| Lua stdlib + vim.* | `/usr/share/nvim/runtime/doc/lua.txt` |
| Nvim API (vim.api.*) | `/usr/share/nvim/runtime/doc/api.txt` |
| vim options | `/usr/share/nvim/runtime/doc/options.txt` |
| autocommands | `/usr/share/nvim/runtime/doc/autocmd.txt` |
| keymaps | `/usr/share/nvim/runtime/doc/map.txt` |
| LSP | `/usr/share/nvim/runtime/doc/lsp.txt` |
| diagnostics | `/usr/share/nvim/runtime/doc/diagnostic.txt` |
| builtin vimscript fns | `/usr/share/nvim/runtime/doc/builtin.txt` |
| filetype | `/usr/share/nvim/runtime/doc/filetype.txt` |
| writing plugins | `/usr/share/nvim/runtime/doc/lua-plugin.txt` |

## Help Tag Format

Tags are defined as `*tag-name*` and referenced as `|tag-name|`. To find a tag definition:
```
Grep: pattern="\*tag-name\*" path="/usr/share/nvim/runtime/doc/"
```

Options use `'option'` syntax. Context prefixes: `v_` Visual, `i_` Insert, `c_` Cmdline.
