#!/usr/bin/env python3
"""Symlinks only. Idempotent, safe to rerun as often as you like.

  meta/link.py                              active profile
  meta/link.py zsh git scripts              named modules
  meta/link.py --dry-run --verbose
  meta/link.py --profile windows --dry-run  check another profile from here
  meta/link.py --clean                      drop broken symlinks into the repo
"""

from __future__ import annotations

from dotlib import (
    ARCH,
    DOTFILES,
    LINUX,
    MAC,
    WIN,
    WSL,
    copy_if_absent,
    link,
    main,
    mkdir,
)

UNIX = not WIN


# --- base -----------------------------------------------------------------


def module_base_dirs():
    for d in ("~/Downloads", "~/bin", "~/.fonts", "~/obsidian-vaults",
              "~/work", "~/personal", "~/open-source"):
        mkdir(d)


# --- shell ----------------------------------------------------------------


def module_local():
    copy_if_absent("local/commonrc.local.example", DOTFILES / "local/commonrc.local")
    link("local/commonrc.local", "~/.commonrc.local")


def module_bash():
    if LINUX or MAC:
        link("bash/bashrc", "~/.bashrc")
        link("bash/profile_bash", "~/.profile")
    elif WIN:
        link("bash/win_bashrc", "~/.bashrc")


def module_zsh():
    link("zsh/zshrc", "~/.zshrc")
    link("zsh/zshenv", "~/.zshenv")
    link("zsh/zprofile", "~/.zprofile")
    link("libs/zplug", "~/.zplug")
    link("libs/bashmarks/bashmarks.sh", "~/.local/bin/bashmarks.sh")


def module_fish():
    link("fish/config.fish", "~/.config/fish/config.fish")


def module_spaceship():
    link("spaceship/spaceship.zsh", "~/.config/spaceship.zsh")


def module_less():
    link("less/lessfilter.sh", "~/.config/less/lessfilter.sh")


# --- terminals ------------------------------------------------------------


def module_ghostty():
    link("ghostty/config", "~/.config/ghostty/config")
    if LINUX:
        link("ghostty/linux-platform.conf", "~/.config/ghostty/platform.conf")
    elif MAC:
        link("ghostty/mac-platform.conf", "~/.config/ghostty/platform.conf")


def module_alacritty():
    # alacritty.toml is deliberately not linked on Linux: the live file has
    # diverged from the repo copy and stays unversioned.
    if LINUX:
        link("alacritty/alacritty_tokyonight_night.toml",
             "~/.config/alacritty/alacritty_tokyonight_night.toml")
        link("alacritty/alacritty.yml", "~/.config/alacritty/alacritty.yml")
        link("alacritty/alacritty_tokyonight_night.yml",
             "~/.config/alacritty/alacritty_tokyonight_night.yml")
    elif MAC:
        link("alacritty/alacritty.toml", "~/.config/alacritty/alacritty.toml")
        link("alacritty/alacritty_tokyonight_night.toml",
             "~/.config/alacritty/alacritty_tokyonight_night.toml")
    elif WIN:
        link("alacritty/alacritty.yml", "~/AppData/Roaming/alacritty/alacritty.yml")


def module_kitty():
    link("kitty", "~/.config/kitty")
    if LINUX and not WSL:
        link("~/.local/kitty.app/bin/kitty", "~/.local/bin/kitty")


def module_wezterm():
    if WIN:
        link("wezterm/wezterm.lua", "~/.config/wezterm/wezterm.lua")


def module_windows_terminal():
    if WIN:
        link("windows-terminal/settings.json",
             "~/AppData/Local/packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe"
             "/LocalState/settings.json")


# --- git ------------------------------------------------------------------


def module_git():
    link("git/gitconfig", "~/.gitconfig")
    link("git/gitconfig-work", "~/.gitconfig-work")
    link("git/global-gitignore", "~/.gitignore")
    if WSL:
        link("git/gitconfig-credential-wsl", "~/.gitconfig-credential")
    elif LINUX:
        link("git/gitconfig-credential-oauth", "~/.gitconfig-credential")
    elif WIN:
        link("git/gitconfig-credential-store", "~/.gitconfig-credential")
    elif MAC:
        link("git/gitconfig-credential-manager-mac", "~/.gitconfig-credential")


def module_gitui():
    dest = "~/AppData/Roaming/gitui" if WIN else "~/.config/gitui"
    link("gitui/key_bindings.ron", f"{dest}/key_bindings.ron")


def module_git_depgraph():
    link("libs/git-madge/git-madge", "~/bin/git-madge")
    link("scripts/git-depgraph.sh", "~/bin/git-depgraph")


# --- editors --------------------------------------------------------------


def module_nvim():
    link("nvim/nvim", "~/AppData/Local/nvim" if WIN else "~/.config/nvim")
    if LINUX or MAC:
        link("nvim/vscode-nvim", "~/.config/nvim-vscode")


def module_ideavim():
    if MAC:
        link("ideavim/ideavimrc", "~/.ideavimrc")


def module_vrapper():
    if WIN:
        link("vrapper/vrapperrc", "~/.vrapperrc")
        link("vrapper/eclipse.user.setup",
             "~/.eclipse/org.eclipse.oomph.setup/setups/user.setup")


# --- tools ----------------------------------------------------------------


def module_cspell():
    link("cspell/cspell.json", "~/.cspell.json")


def module_tmux():
    link("tmux/tmux.conf", "~/.tmux.conf")


def module_bat():
    if UNIX:
        link("bat/themes", "~/.config/bat/themes")


def module_yamllint():
    link("yamllint/config.yml", "~/.config/yamllint/config")


def module_zathura():
    link("zathura/zathurarc", "~/.config/zathura/zathurarc")


def module_fyodor():
    link("fyodor/fyodor.toml", "~/.config/fyodor/fyodor.toml")


def module_opencode():
    link("opencode/opencode.jsonc", "~/.config/opencode/opencode.jsonc")


def module_claude():
    link("claude-config/global/settings.json", "~/.claude/settings.json")
    link("claude-config/global/CLAUDE.md", "~/.claude/CLAUDE.md")


# --- desktop --------------------------------------------------------------


def module_aerospace():
    if MAC:
        link("aerospace/aerospace.toml", "~/.config/aerospace/aerospace.toml")


def module_i3_endeavour():
    if LINUX:
        link("i3-endeavour/rofi", "~/.config/rofi")
        link("i3-endeavour/i3", "~/.config/i3")
        link("i3-endeavour/picom.conf", "~/.config/picom.conf")


def module_powertoys():
    if WIN:
        root = "~/AppData/Local/Microsoft/PowerToys"
        link("powertoys/settings.json", f"{root}/settings.json")
        link("powertoys/Keyboard_Manager/settings.json",
             f"{root}/Keyboard Manager/settings.json")
        link("powertoys/Keyboard_Manager/default.json",
             f"{root}/Keyboard Manager/default.json")


def module_wsl():
    if WIN:
        link("wsl/wslconfig", "~/.wslconfig")
    elif WSL:
        # make windows executables available inside wsl
        for exe, path in {
            "explorer.exe": "/mnt/c/Windows/explorer.exe",
            "wsl.exe": "/mnt/c/Windows/System32/wsl.exe",
            "powershell.exe": "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe",
            "ssh.exe": "/mnt/c/Windows/System32/OpenSSH/ssh.exe",
            "cmd.exe": "/mnt/c/Windows/System32/cmd.exe",
        }.items():
            link(path, f"~/bin/{exe}")


# --- scripts --------------------------------------------------------------

_SCRIPTS_ALL = {
    "~/bin/jenkinslint": "scripts/jenkinslint.sh",
    "~/bin/git-review-diff": "scripts/git-review-diff.sh",
    "~/bin/worktree-create": "scripts/git-create-worktree.sh",
    "~/bin/init-worktree": "scripts/git-init-worktree.sh",
    "~/bin/git-cat-all-objects": "scripts/git-cat-all-objects.sh",
    "~/bin/git-stat": "scripts/git-stat.sh",
    "~/bin/git-ch": "scripts/git-fzf-checkout.sh",
    "~/bin/find_up.sh": "scripts/find_up.sh",
    "~/bin/git-all-executable": "scripts/git-all-executable.sh",
    "~/bin/fzf-dir": "scripts/fzf-dir.sh",
    "~/bin/jira-issues-to-confluence-markup": "scripts/jira-issues-to-confluence-markup.sh",
    "~/bin/fnpm": "scripts/fnpm.sh",
    "~/bin/worktree-clean": "scripts/worktree-clean.sh",
    "~/bin/copy": "scripts/copy.sh",
    "~/bin/pasta": "scripts/pasta.sh",
    "~/bin/pastas": "scripts/pastas.sh",
}

_SCRIPTS_UNIX = {
    "~/bin/live-grep": "scripts/live-grep.sh",
    "~/bin/kdiff-merge.sh": "scripts/kdiff-merge.sh",
    "~/.config/fzf-run/fzf-run.json": "scripts/fzf-run/fzf-run.json",
}

_SCRIPTS_LINUX = {
    "~/bin/prettier-changes": "scripts/prettier-changes.sh",
    "~/bin/weather": "scripts/weather.sh",
    "~/bin/rain": "scripts/rain.sh",
    "~/bin/prettier-format-staged": "scripts/prettier-format-staged.sh",
    "~/bin/clean-node-modules": "scripts/clean-node-modules.sh",
    "~/bin/i3exit.sh": "scripts/i3exit.sh",
}

_SCRIPTS_WSL = {
    "~/wsl-forward-windows-port.sh": "scripts/wsl2/wsl-forward-windows-port.sh",
}

_SCRIPTS_WIN = {
    "~/bin/eclipse-open": "scripts/eclipse-open.sh",
    "~/bin/man": "scripts/man-on-windows.sh",
}


def module_scripts():
    groups = [_SCRIPTS_ALL]
    if UNIX:
        groups.append(_SCRIPTS_UNIX)
    if LINUX:
        groups.append(_SCRIPTS_LINUX)
    if WSL:
        groups.append(_SCRIPTS_WSL)
    if WIN:
        groups.append(_SCRIPTS_WIN)
    for group in groups:
        for dest, src in group.items():
            link(src, dest)


# --- registry -------------------------------------------------------------

MODULES = {
    "base": module_base_dirs,
    "local": module_local,
    "bash": module_bash,
    "zsh": module_zsh,
    "fish": module_fish,
    "spaceship": module_spaceship,
    "less": module_less,
    "ghostty": module_ghostty,
    "alacritty": module_alacritty,
    "kitty": module_kitty,
    "wezterm": module_wezterm,
    "windows-terminal": module_windows_terminal,
    "git": module_git,
    "gitui": module_gitui,
    "git-depgraph": module_git_depgraph,
    "nvim": module_nvim,
    "ideavim": module_ideavim,
    "vrapper": module_vrapper,
    "cspell": module_cspell,
    "tmux": module_tmux,
    "bat": module_bat,
    "yamllint": module_yamllint,
    "zathura": module_zathura,
    "fyodor": module_fyodor,
    "opencode": module_opencode,
    "claude": module_claude,
    "aerospace": module_aerospace,
    "i3-endeavour": module_i3_endeavour,
    "powertoys": module_powertoys,
    "wsl": module_wsl,
    "scripts": module_scripts,
}

_SHELL = ["base", "local", "bash", "zsh", "spaceship", "less", "ghostty", "alacritty"]

PROFILES = {
    "arch": ["base", "cspell", "git", "tmux", "scripts", "nvim", "gitui",
             "git-depgraph", "zathura", "bat", "yamllint"],
    "arch-shell": _SHELL,
    "ubuntu": ["base", "cspell", "git", "tmux", "scripts", "nvim", "gitui",
               "git-depgraph", "zathura", "wsl", "bat", "yamllint"],
    "ubuntu-shell": _SHELL,
    "mac": ["base", "local", "zsh", "spaceship", "less", "ghostty", "alacritty",
            "aerospace", "cspell", "git", "tmux", "scripts", "nvim", "gitui",
            "bat", "yamllint"],
    "windows": ["base", "cspell", "local", "git", "bash", "nvim", "gitui", "wsl",
                "wezterm", "windows-terminal", "vrapper", "powertoys",
                "alacritty"],
}


if __name__ == "__main__":
    raise SystemExit(main(MODULES, PROFILES, "symlink dotfiles"))
