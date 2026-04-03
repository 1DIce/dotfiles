# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration written entirely in Lua. It lives within a larger dotfiles repo at `~/dotfiles/`, symlinked to Neovim's config path. The namespace prefix is `ld` (all modules under `lua/ld/`).

## Architecture

**Entry point:** `init.lua` loads modules in this order:
1. `ld.defaults` — vim options, autocommands, custom commands, shell escaping
2. `ld.utils.remaps` — global keymap helper functions (`nnoremap`, `vnoremap`, `bufnoremap`, etc.) exposed as globals
3. `ld.init-lazy` — bootstraps lazy.nvim plugin manager; leader is `<Space>`, localleader is `ö`
4. `ld.utils` — utility modules (file, path, json, globals)
5. `ld.theme` — colorscheme (tokyonight)
6. `ld.lsp` — LSP configuration (mason, server configs, format-on-save)
7. `ld.remaps` — general keymaps
8. `ld.diagnostics` — diagnostic display settings

**Plugin specs** are in `lua/ld/lazy/` — each file returns a lazy.nvim spec table. `lua/ld/lazy/init.lua` lists always-loaded plugins; other files are auto-discovered by lazy.nvim via `spec = "ld.lazy"`.

**LSP setup** (`lua/ld/lsp/`):
- `settings.lua` — mason install lists, per-server configs, capability merging (blink.cmp + lsp-file-operations). Servers are configured via `vim.lsp.config()` / `vim.lsp.enable()` (native Neovim 0.11+ API).
- `events.lua` — LspAttach autocmd (sets keymaps via `ld.lsp.remaps`), format-on-save autocmds, LSP progress notifications.
- `servers/` — language-specific configs (kotlin, rust via rustaceanvim, java via nvim-jdtls, go, typescript via vtsls, etc.)
- Deno vs TypeScript: `functions.is_deno_workspace()` switches between `denols` and `vtsls`.

**Completion:** blink.cmp with LuaSnip snippets. Sources: lsp, lazydev, snippets, path, buffer (+ dadbod for SQL).

**Key patterns to know:**
- Global keymap helpers (`nnoremap`, `bufnoremap`, etc.) are defined in `utils/remaps.lua` and used everywhere without requiring them — they are intentionally global.
- `ftplugin/` has filetype-specific settings (java uses nvim-jdtls, gitcommit, sql).
- Format-on-save is handled per filetype in `lsp/events.lua` — TypeScript gets organize-imports + format; Python uses ruff; other filetypes use `vim.lsp.buf.format()`.

## Formatting

Lua files are formatted with **stylua** (installed via mason). The config uses 2-space indentation throughout.
