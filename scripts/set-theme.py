#!/usr/bin/env python3

# Original source https://github.com/nickjj/dotfiles

import argparse
import fileinput
import os
import re
import sys
import textwrap

from pathlib import Path
from subprocess import run, PIPE


THEMES = {
    "gruvbox-material": {
        "dark": {
            "kitty": {"themeName": "Gruvbox Dark"},
            "terminal": {
                "colorScheme": "Gruvbox Dark",
                "cursorColor": "#ffb261",
            },
            "tmux": {
                "status-style": "fg=colour244",
                "window-status-current-style": "fg=colour222",
                "pane-border-style": "fg=colour240",
                "pane-active-border-style": "fg=colour243",
            },
        },
        "light": {
            "kitty": {"themeName": "Gruvbox Light"},
            "terminal": {
                "colorScheme": "Gruvbox Light",
                "cursorColor": "#ffb261",
            },
            "tmux": {
                "status-style": "fg=colour179",
                "window-status-current-style": "fg=colour172",
                "pane-border-style": "fg=colour186",
                "pane-active-border-style": "fg=colour178",
            },
        },
    },
    "dracula": {
        "dark": {
            "kitty": {"themeName": "Dracula"},
            "terminal": {
                "colorScheme": "Dracula",
            },
            "tmux": {
                "status-style": "fg=colour110",
                "window-status-current-style": "fg=colour39",
                "pane-border-style": "fg=colour240",
                "pane-active-border-style": "fg=colour243",
            },
        },
    },
}


def get_windows_user():
    result = run(
        ["powershell.exe", "$env:UserName"], stdout=PIPE, universal_newlines=True
    )
    return result.stdout.rstrip()


def in_wsl():
    return 'microsoft-standard' in uname().release


HOME = str(Path.home())
SHELL_CONFIG = f'{os.environ.get("XDG_CONFIG_HOME")}/zsh/.zshrc'
TMUX_CONFIG = f"{HOME}/.tmux.conf"
VIM_CONFIG = f"{HOME}/.config/nvim/lua/ld/theme.lua"


def edit_inplace(file, preserve_symlinks=True):
    if preserve_symlinks:
        file = os.path.realpath(file)

    return fileinput.input(files=(file,), inplace=True)


def active_theme_and_background():
    with open(VIM_CONFIG, "r") as f:
        for line in f:
            match = re.match("^set background=(.*)$", line)
            if match:
                bg = match.group(1)
                continue

            match = re.match("^colorscheme (.*$)$", line)
            if match:
                theme = match.group(1)
                continue
    try:
        return theme, bg
    except NameError:
        sys.exit(
            'error: "set background" or "colorscheme" statement not found'
            f" in {VIM_CONFIG}"
        )


def change_kitty_terminal_theme(theme, bg):
    terminal_options = THEMES[theme][bg]["kitty"]
    kittyThemeName = terminal_options["themeName"]
    run(
        ["kitty", "+kitten", "theme", "--reload-in=all", kittyThemeName])

    return


def change_windows_terminal_theme(theme, bg):
    terminal_options = THEMES[theme][bg]["terminal"]
    windows_terminal_config = f"/c/Users/{get_windows_user()}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" # noqa: E501

    with edit_inplace(windows_terminal_config) as f:
        for line in f:
            for key, value in terminal_options.items():
                line = re.sub(rf'"{key}": ".*"', f'"{key}": "{value}"', line)
            sys.stdout.write(line)


def change_tmux_theme(theme, bg):
    tmux_options = THEMES[theme][bg]["tmux"]

    with edit_inplace(TMUX_CONFIG) as f:
        for line in f:
            for key, value in tmux_options.items():
                line = re.sub(rf"^set -g {key} .*$", f"set -g {key} {value}", line)
            sys.stdout.write(line)

    run(["tmux", "source-file", TMUX_CONFIG])


def change_vim_theme(theme, bg):
    with edit_inplace(VIM_CONFIG) as f:
        for line in f:
            line = re.sub(r"^vim.cmd\('colorscheme .*'\)$",
                    f"vim.cmd\('colorscheme {theme}'\)", line)
            # line = re.sub(r"^set background=.*$", f"set background={bg}", line)
            sys.stdout.write(line)


def change_fzf_theme(bg):
    with edit_inplace(SHELL_CONFIG) as f:
        for line in f:
            re.sub(
                r'FZF_DEFAULT_OPTS="--color=.*"$',
                f'FZF_DEFAULT_OPTS="--color={bg}"',
                line,
            )
            sys.stdout.write(line)


def parseargs():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent(
            """\
        Set a theme along with optionally toggling dark and light backgrounds.
        """
        ),
    )
    parser.add_argument("theme", choices=THEMES, nargs="?", help="the theme name")
    parser.add_argument(
        "--toggle-bg",
        action="store_true",
        help="toggle the background between dark and light",
    )
    args = parser.parse_args()

    if len(sys.argv) == 1:
        parser.error("at least one argument is required")

    return args


def main():
    args = parseargs()

    theme, bg = active_theme_and_background()

    if args.theme:
        theme = args.theme

    if args.toggle_bg:
        bg = "light" if bg == "dark" else "dark"

    if in_wsl():
        change_windows_terminal_theme(theme, bg)
    else:
        # Kitty terminal
        change_kitty_terminal_theme(theme, bg)

    change_tmux_theme(theme, bg)
    change_vim_theme(theme, bg)
    change_fzf_theme(bg)


if __name__ == "__main__":
    main()




