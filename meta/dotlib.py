#!/usr/bin/env python3
"""Shared engine for meta/link.py and meta/install.py.

Stdlib only. Paths are resolved against the repo root, so the invocation
directory does not matter.
"""

from __future__ import annotations

import argparse
import enum
import os
import platform
import shutil
import subprocess
import sys
from pathlib import Path

DOTFILES = Path(__file__).resolve().parent.parent
HOME = Path.home()


class Platform(enum.Enum):
    LINUX = "Linux"
    MAC = "Darwin"
    WINDOWS = "Windows"

    @classmethod
    def current(cls) -> Platform | None:
        try:
            return cls(platform.system())
        except ValueError:
            return None


class Profile(enum.Enum):
    """A named target. Autodetect only ever yields one of the first four."""

    ARCH = "arch"
    UBUNTU = "ubuntu"
    MAC = "mac"
    WINDOWS = "windows"
    ARCH_SHELL = "arch-shell"
    UBUNTU_SHELL = "ubuntu-shell"


class CliFlag(enum.Enum):
    DRY_RUN = "dry_run"
    FORCE = "force"
    VERBOSE = "verbose"


PLATFORM = Platform.current()

# Convenience aliases. Modules read as plain conditions, not enum comparisons.
LINUX = PLATFORM is Platform.LINUX
MAC = PLATFORM is Platform.MAC
WIN = PLATFORM is Platform.WINDOWS
# WSL and ARCH are facets of LINUX, not platforms of their own.
WSL = LINUX and bool(os.environ.get("WSL_DISTRO_NAME"))
ARCH = LINUX and Path("/etc/arch-release").exists()

_flags: set[CliFlag] = set()


def set_flags(*flags: CliFlag) -> None:
    _flags.clear()
    _flags.update(flags)


def flag(f: CliFlag) -> bool:
    return f in _flags


_stats = {"ok": 0, "link": 0, "relink": 0, "conflict": 0, "error": 0, "skip": 0}
_touched_dirs: set[Path] = set()


# --- output ---------------------------------------------------------------


def _say(msg: str) -> None:
    print(msg)


def _warn(msg: str) -> None:
    print(msg, file=sys.stderr)


def _count(kind: str) -> None:
    _stats[kind] += 1


# --- path resolution ------------------------------------------------------


def dest_path(dest) -> Path:
    """Destination paths are absolute or ~-relative."""
    return Path(os.path.expanduser(str(dest)))


def src_path(src) -> Path:
    """Sources are repo-relative, absolute, or ~-relative."""
    text = str(src)
    if text.startswith("~"):
        return Path(os.path.expanduser(text))
    p = Path(text)
    return p if p.is_absolute() else DOTFILES / p


# --- actions --------------------------------------------------------------


def mkdir(path) -> None:
    d = dest_path(path)
    if d.is_dir():
        _count("ok")
        if flag(CliFlag.VERBOSE):
            _say(f"  ok       {d}")
        return
    _count("link")
    _say(f"  mkdir    {d}")
    if not flag(CliFlag.DRY_RUN):
        d.mkdir(parents=True, exist_ok=True)


def _backup(path: Path) -> Path:
    bak = path.with_name(path.name + ".bak")
    i = 1
    while bak.exists() or bak.is_symlink():
        bak = path.with_name(f"{path.name}.bak.{i}")
        i += 1
    return bak


def link(src, dest) -> None:
    s = src_path(src)
    d = dest_path(dest)
    _touched_dirs.add(d.parent)

    if not s.exists() and not s.is_symlink():
        _count("error")
        _warn(f"  ERROR    missing source: {s}")
        return

    if d.is_symlink():
        current = os.readlink(d)
        if Path(current) == s:
            _count("ok")
            if flag(CliFlag.VERBOSE):
                _say(f"  ok       {d}")
            return
        _count("relink")
        _say(f"  relink   {d} -> {s}")
        if not flag(CliFlag.DRY_RUN):
            d.unlink()
            _symlink(s, d)
        return

    if d.exists():
        if not flag(CliFlag.FORCE):
            _count("conflict")
            _warn(f"  CONFLICT {d} exists and is not a symlink (use --force)")
            return
        bak = _backup(d)
        _count("relink")
        _say(f"  backup   {d} -> {bak}")
        _say(f"  relink   {d} -> {s}")
        if not flag(CliFlag.DRY_RUN):
            shutil.move(str(d), str(bak))
            _symlink(s, d)
        return

    _count("link")
    _say(f"  link     {d} -> {s}")
    if not flag(CliFlag.DRY_RUN):
        _symlink(s, d)


def _symlink(s: Path, d: Path) -> None:
    d.parent.mkdir(parents=True, exist_ok=True)
    os.symlink(s, d, target_is_directory=s.is_dir())


def copy_if_absent(src, dest) -> None:
    s = src_path(src)
    d = dest_path(dest)
    if d.exists():
        _count("ok")
        if flag(CliFlag.VERBOSE):
            _say(f"  ok       {d}")
        return
    if not s.exists():
        _count("error")
        _warn(f"  ERROR    missing source: {s}")
        return
    _count("link")
    _say(f"  copy     {s} -> {d}")
    if not flag(CliFlag.DRY_RUN):
        d.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(s, d)


def run(*cmd, check: bool = True, shell: bool = False) -> int:
    """Run a command. Used by install.py; a no-op under --dry-run."""
    printable = cmd[0] if shell else " ".join(str(c) for c in cmd)
    _say(f"  run      {printable}")
    if flag(CliFlag.DRY_RUN):
        return 0
    args = cmd[0] if shell else [str(c) for c in cmd]
    proc = subprocess.run(args, shell=shell)
    if proc.returncode != 0:
        _count("error")
        _warn(f"  ERROR    exit {proc.returncode}: {printable}")
        if check:
            raise SystemExit(proc.returncode)
    return proc.returncode


def clean() -> None:
    """Remove broken symlinks that point into the repo.

    Only the directories touched by this run are scanned, plus ~ itself.
    """
    dirs = sorted(_touched_dirs | {HOME})
    for directory in dirs:
        if not directory.is_dir():
            continue
        for entry in sorted(directory.iterdir()):
            if not entry.is_symlink() or entry.exists():
                continue
            target = Path(os.readlink(entry))
            if not target.is_absolute():
                target = entry.parent / target
            if DOTFILES not in target.parents:
                continue
            _count("relink")
            _say(f"  clean    {entry} (broken -> {target})")
            if not flag(CliFlag.DRY_RUN):
                entry.unlink()


# --- profile resolution ---------------------------------------------------


def autodetect_profile() -> Profile | None:
    if WIN:
        return Profile.WINDOWS
    if MAC:
        return Profile.MAC
    if ARCH:
        return Profile.ARCH
    if LINUX:
        return Profile.UBUNTU
    return None


def resolve_profile(requested: str | None) -> str:
    if requested:
        return requested
    env = os.environ.get("DOTFILES_PROFILE")
    if env:
        return env
    local = DOTFILES / "local" / "profile"
    if local.is_file():
        text = local.read_text().strip()
        if text:
            return ",".join(line.strip() for line in text.splitlines() if line.strip())
    detected = autodetect_profile()
    return detected.value if detected else ""


# --- CLI ------------------------------------------------------------------


def main(modules: dict, profiles: dict, description: str) -> int:
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument(
        "modules", nargs="*", help="module names (default: active profile)"
    )
    parser.add_argument(
        "-n", "--dry-run", action="store_true", help="report, change nothing"
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="replace real files (backs up to .bak)",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="also report already-correct entries",
    )
    parser.add_argument("-p", "--profile", help="profile name, or comma separated list")
    parser.add_argument(
        "-l", "--list", action="store_true", help="list modules and profiles"
    )
    parser.add_argument(
        "-c",
        "--clean",
        action="store_true",
        help="remove broken symlinks pointing into the repo",
    )
    args = parser.parse_args()

    set_flags(*(f for f in CliFlag if getattr(args, f.value)))

    if args.list:
        _say("profiles:")
        for prof, mods in profiles.items():
            _say(f"  {prof.value}: {' '.join(mods)}")
        _say("")
        _say("modules:")
        _say("  " + " ".join(sorted(modules)))
        orphans = sorted(set(modules) - {m for mods in profiles.values() for m in mods})
        if orphans:
            _say("")
            _say("not in any profile (invoke by name):")
            _say("  " + " ".join(orphans))
        return 0

    if args.modules:
        selected = list(dict.fromkeys(args.modules))
        source = "modules"
    else:
        profile = resolve_profile(args.profile)
        if not profile:
            _warn("ERROR    no profile given and platform autodetect failed")
            return 1
        selected = []
        for name in profile.split(","):
            name = name.strip()
            try:
                mods = profiles[Profile(name)]
            except (ValueError, KeyError):
                _warn(f"ERROR    unknown profile: {name}")
                return 1
            for mod in mods:
                if mod not in selected:
                    selected.append(mod)
        source = f"profile {profile}"

    unknown = [m for m in selected if m not in modules]
    if unknown:
        _warn(f"ERROR    unknown module(s): {' '.join(unknown)}")
        return 1

    prefix = "[dry-run] " if flag(CliFlag.DRY_RUN) else ""
    _say(f"{prefix}{description} ({source})")

    for name in selected:
        _say(f"\n--- {name}")
        modules[name]()

    if args.clean:
        _say("\n--- clean")
        clean()

    _say(
        "\n{ok} ok, {link} new, {relink} changed, {conflict} conflict, {error} error".format(
            **_stats
        )
    )
    return 1 if (_stats["error"] or _stats["conflict"]) else 0
