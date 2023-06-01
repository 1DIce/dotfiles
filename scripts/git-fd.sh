#!/usr/bin/env bash
preview="git -c delta.side-by-side=false diff --color=always $@ -- {-1} | delta"
git diff $@ --name-only | fzf -m --ansi --preview "$preview"
