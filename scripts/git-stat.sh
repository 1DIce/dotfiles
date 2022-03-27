#! /usr/bin/env bash

reviewBase=$(printf 'origin/master\norigin/lts/10.10\norigin/lts/10.0' | fzf)
mergeBase=$(git merge-base HEAD "$reviewBase")
git diff --stat "$mergeBase"
