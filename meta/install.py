#!/usr/bin/env python3
"""Package installation. Explicit only: a bare invocation refuses.

  meta/install.py --list                          what this profile has
  meta/install.py --dry-run steps                 print commands, run nothing
  meta/install.py packages                        every manager for the profile
  meta/install.py packages pacman nix             named managers only
  meta/install.py steps                           every imperative step
  meta/install.py fonts nvim bat-cache            named steps only

Bootstrap steps come first in the step order and are the ones that have to
run before `packages`:

  meta/install.py steps nix apt-ppas scoop-buckets
  meta/install.py packages
  meta/install.py steps

Symlinking lives in meta/link.py; this file never touches ~.
"""

from __future__ import annotations

import sys

from dotlib import DOTFILES, WSL, CliFlag, Profile, autodetect_profile, run, set_flags

# --- managers -------------------------------------------------------------

MANAGERS = {
    "pacman": "sudo pacman -S --needed --noconfirm {pkgs}",
    "yay": "yay -S --noconfirm {pkgs}",
    "apt": "sudo apt install -y {pkgs}",
    "nix": "nix-env -iA {pkgs}",
    "brew": "brew install {pkgs}",
    "cask": "brew install --cask {pkgs}",
    "scoop": "scoop install {pkgs}",
    "npm": "npm install -g {pkgs}",
    "pipx": "pipx install {pkgs}",
    "cargo": "cargo install {pkgs}",
    "gem": "sudo gem install {pkgs}",
}

# managers that take one package per invocation
ONE_AT_A_TIME = {"pipx", "cargo"}

# nix wants fully qualified attribute paths
PREFIXED = {"nix": "nixpkgs."}

# --- package tables -------------------------------------------------------

_NIX = [
    "fd",
    "unzip",
    "trash-cli",
    "ripgrep",
    "bat",
    "jq",
    "imagemagick",
    "graphviz",
    "thefuck",
    "just",
    "fzf",
    "eza",
    "delta",
    "deno",
    "go",
    "rustup",
    "volta",
    "tmux",
    "gitui",
    "pipx",
    "git-credential-oauth",
]

_NPM = ["cspell", "prettier", "@angular/cli", "@vlabo/cspell-lsp"]

_CARGO = [
    "--git https://github.com/1DIce/tmux-sessioneer.git",
    "--git https://github.com/1DIce/coding-flow",
]

PACKAGES = {
    Profile.ARCH: {
        "pacman": [
            "gcc",
            "make",
            "cmake",
            "fuse2",
            "sqlite",
            "chafa",
            "git",
            "watchexec",
            "tree-sitter-cli",
            "kdiff3",
            "zathura",
            "xclip",
        ],
        "yay": ["appimagelauncher"],
        # watchexec comes from pacman here, not nix
        "nix": _NIX,
        "npm": _NPM + ["madge"],
        "pipx": ["yamllint", "black"],
        "cargo": _CARGO,
    },
    Profile.UBUNTU: {
        "apt": [
            "build-essential",
            "cmake",
            "rename",
            "libfuse2",
            "sqlite3",
            "libsqlite3-dev",
            "python-is-python3",
            "python3-venv",
            "chafa",
            "git-gui",
            "luarocks",
            "direnv",
        ]
        + (
            ["wl-clipboard", "xdg-utils"]
            if WSL
            else ["kdiff3", "xclip", "zathura", "appimagelauncher"]
        ),
        "nix": _NIX + ["watchexec"],
        "npm": _NPM + ["madge", "git-format-staged", "tldr"],
        "pipx": ["yamllint", "black"],
        "cargo": _CARGO,
        "gem": ["fyodor"],
    },
    Profile.MAC: {
        "brew": [
            "fd",
            "ripgrep",
            "bat",
            "jq",
            "thefuck",
            "fzf",
            "eza",
            "delta",
            "chafa",
            "git-gui",
            "luarocks",
            "kdiff3",
            "watchexec",
            "rustup",
            "ghostty",
            "docker",
            "docker-compose",
            "just",
            "direnv",
            "tree-sitter-cli",
            "gitui",
            "tmux",
            "pipx",
        ],
        "cask": ["nikitabobko/tap/aerospace", "git-credential-manager"],
        "npm": _NPM,
        "pipx": ["yamllint", "black"],
        "cargo": _CARGO,
    },
    Profile.WINDOWS: {
        "scoop": [
            "ripgrep",
            "fd",
            "sqlite",
            "deno",
            "gcc",
            "make",
            "gitui",
            "lazygit",
            "delta",
            "cmake",
            "fzf",
            "copyq",
            "carnac",
            "jq",
            "eza",
        ],
        "npm": _NPM,
        "cargo": ["--git https://github.com/1DIce/coding-flow"],
    },
}

# --- imperative steps -----------------------------------------------------

STEPS: dict[str, tuple[frozenset[Profile], object]] = {}


def step(*profiles: Profile):
    """Register a step under its function name, kebab-cased."""

    def register(fn):
        STEPS[fn.__name__.strip("_").replace("_", "-")] = (frozenset(profiles), fn)
        return fn

    return register


# bootstrap: these have to run before `packages`


@step(Profile.UBUNTU)
def nix():
    run("sh <(curl -L https://nixos.org/nix/install) --daemon", shell=True)


@step(Profile.UBUNTU)
def apt_ppas():
    run(
        "sudo add-apt-repository ppa:git-core/ppa -y "
        "&& sudo apt update && sudo apt install git -y",
        shell=True,
    )
    if not WSL:
        run(
            "sudo add-apt-repository ppa:appimagelauncher-team/stable -y "
            "&& sudo apt update",
            shell=True,
        )


@step(Profile.WINDOWS)
def scoop_buckets():
    run("scoop bucket add main && scoop bucket add extras", shell=True)


@step(Profile.WINDOWS)
def pipx_path():
    run("python -m pip install --user pipx && python -m pipx ensurepath", shell=True)


# the rest: after `packages`


@step(Profile.ARCH, Profile.UBUNTU)
def fonts():
    run(
        "rm -f ~/Downloads/UbuntuMono.zip"
        " && wget -O ~/Downloads/UbuntuMono.zip"
        " https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip"
        " && unzip ~/Downloads/UbuntuMono.zip -d ~/.fonts"
        " && fc-cache -fv"
        " && rm -v ~/Downloads/UbuntuMono.zip",
        shell=True,
    )


@step(Profile.ARCH, Profile.UBUNTU, Profile.MAC, Profile.WINDOWS)
def nvim():
    if PROFILE is Profile.WINDOWS:
        run("scoop install neovim", shell=True)
    elif PROFILE is Profile.MAC:
        run("brew install neovim", shell=True)
    else:
        run(
            "rm -f ~/bin/nvim"
            " && wget -O ~/bin/nvim"
            " https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage"
            " && chmod +x ~/bin/nvim",
            shell=True,
        )


@step(Profile.ARCH, Profile.UBUNTU, Profile.MAC)
def rustup():
    run("rustup default stable", shell=True)


@step(Profile.ARCH, Profile.UBUNTU, Profile.MAC)
def volta():
    if PROFILE is Profile.MAC:
        run("curl https://get.volta.sh | bash -s -- --skip-setup", shell=True)
    run("volta install node@22 && volta install yarn", shell=True)


@step(Profile.ARCH, Profile.UBUNTU, Profile.MAC)
def bat_cache():
    # rebuild the bat cache so the linked themes are picked up
    run("bat cache --build", shell=True)


@step(Profile.UBUNTU, Profile.MAC)
def fish():
    if PROFILE is Profile.MAC:
        run("brew install fish", shell=True)
    else:
        run(
            "sudo add-apt-repository ppa:fish-shell/release-4 -y "
            "&& sudo apt update && sudo apt install fish -y",
            shell=True,
        )


@step(Profile.UBUNTU)
def cheat_sheets():
    run(
        "curl https://cht.sh/:cht.sh > ~/bin/cht.sh && chmod +x ~/bin/cht.sh",
        shell=True,
    )
    run(
        "bash <(curl -sL "
        "https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)",
        shell=True,
    )


@step(Profile.UBUNTU)
def marktext():
    if WSL:
        return
    # AppImage plus appimagelauncher integration
    run(
        "wget -O ~/bin/marktext.AppImage"
        " https://github.com/marktext/marktext/releases/latest/download/marktext-x86_64.AppImage"
        " && chmod +x ~/bin/marktext.AppImage"
        " && ail-cli integrate ~/bin/marktext.AppImage",
        shell=True,
    )


@step(Profile.UBUNTU)
def locale():
    if not WSL:
        return
    run(
        "sudo locale-gen en_US.UTF-8 && sudo update-locale LANG=en_US.UTF-8", shell=True
    )


@step(Profile.UBUNTU)
def wsl():
    if not WSL:
        return
    # wsl.conf is not picked up when symlinked, so it gets copied
    run(f"sudo cp {DOTFILES}/wsl/wsl.conf /etc/wsl.conf", shell=True)
    for target, dest in {
        '"$(wslpath "$(wslvar USERPROFILE)")/AppData/Local/Programs/Microsoft VS Code/bin/code"': "~/bin/code",
        '"$(wslpath "$(wslvar USERPROFILE)")/scoop/apps/neovide/current/neovide"': "~/bin/neovide",
        '"$(wslpath "$(wslvar USERPROFILE)")/obsidian-vaults/notes"': "~/obsidian-vaults/notes",
    }.items():
        run(f"ln -sf {target} {dest}", shell=True)


@step(Profile.MAC)
def docker_compose():
    # expose docker compose as a docker cli plugin
    run(
        "mkdir -p ~/.docker/cli-plugins"
        " && ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose"
        " ~/.docker/cli-plugins/docker-compose",
        shell=True,
    )


@step(Profile.WINDOWS)
def gitlab_cli():
    run(
        "deno install --allow-run --allow-env --allow-net --allow-read"
        " --unstable --no-check"
        " https://raw.githubusercontent.com/1DIce/gitlab-cli/main/gitlab-cli.ts",
        shell=True,
    )


# --- driver ---------------------------------------------------------------

PROFILE: Profile | None = None


def install_manager(name: str, pkgs: list[str]) -> None:
    template = MANAGERS[name]
    prefix = PREFIXED.get(name, "")
    names = [prefix + p for p in pkgs]
    if name in ONE_AT_A_TIME:
        for pkg in names:
            run(template.format(pkgs=pkg), shell=True)
    else:
        run(template.format(pkgs=" ".join(names)), shell=True)


def do_packages(names: list[str]) -> int:
    table = PACKAGES[PROFILE]
    unknown = [n for n in names if n not in table]
    if unknown:
        print(
            f"ERROR    no {PROFILE.value} packages for manager(s): {' '.join(unknown)}",
            file=sys.stderr,
        )
        return 1
    for name in names or list(table):
        print(f"\n--- {name}")
        install_manager(name, table[name])
    return 0


def do_steps(names: list[str]) -> int:
    available = [n for n, (profiles, _) in STEPS.items() if PROFILE in profiles]
    unknown = [n for n in names if n not in available]
    if unknown:
        print(
            f"ERROR    step(s) do not apply on {PROFILE.value}: {' '.join(unknown)}",
            file=sys.stderr,
        )
        return 1
    for name in names or available:
        print(f"\n--- {name}")
        STEPS[name][1]()
    return 0


def do_list() -> int:
    print(f"profile: {PROFILE.value}" + (" (wsl)" if WSL else ""))
    print("\nmanagers:")
    for name, pkgs in PACKAGES[PROFILE].items():
        print(f"  {name}: {' '.join(pkgs)}")
    print("\nsteps:")
    print(
        "  " + " ".join(n for n, (profiles, _) in STEPS.items() if PROFILE in profiles)
    )
    return 0


USAGE = """usage: install.py [--dry-run] [--profile NAME] <packages|steps> [name ...]
       install.py --list

installing is explicit: name `packages`, `steps`, or specific ones."""


def main() -> int:
    global PROFILE
    argv = sys.argv[1:]
    dry_run = False
    requested = ""
    listing = False
    rest: list[str] = []

    while argv:
        arg = argv.pop(0)
        if arg in ("-n", "--dry-run"):
            dry_run = True
        elif arg in ("-l", "--list"):
            listing = True
        elif arg in ("-p", "--profile"):
            if not argv:
                print("ERROR    --profile needs a name", file=sys.stderr)
                return 1
            requested = argv.pop(0)
        elif arg in ("-h", "--help"):
            print(__doc__)
            return 0
        else:
            rest.append(arg)

    set_flags(*([CliFlag.DRY_RUN] if dry_run else []))

    try:
        PROFILE = Profile(requested) if requested else autodetect_profile()
    except ValueError:
        PROFILE = None
    if PROFILE not in PACKAGES:
        name = requested or (PROFILE.value if PROFILE else "autodetect failed")
        print(f"ERROR    no packages for profile: {name}", file=sys.stderr)
        return 1

    if listing:
        return do_list()

    if not rest:
        print(USAGE, file=sys.stderr)
        return 1

    kind, names = rest[0], list(dict.fromkeys(rest[1:]))
    prefix = "[dry-run] " if dry_run else ""
    print(f"{prefix}install ({PROFILE.value})", flush=True)

    if kind == "packages":
        return do_packages(names)
    if kind == "steps":
        return do_steps(names)

    # bare list of step names, no `steps` keyword
    return do_steps(list(dict.fromkeys(rest)))


if __name__ == "__main__":
    raise SystemExit(main())
