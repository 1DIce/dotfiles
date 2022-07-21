#!/usr/bin/env bash

BRANCHES=$(git branch --all --no-color \
  | grep -v -E '(^\*)|(HEAD)' \
  | sed -e 's|remotes/origin/||' \
  | grep -E '(feature\/lars\/)|(lts\/10)|(master\/)')
  | sort
  | uniq -u

git checkout "$(echo "$BRANCHES" | fzf | tr -d '[:space:]')"
