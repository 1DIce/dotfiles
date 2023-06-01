#!/usr/bin/env bash

git log --oneline | fzf | awk '{print $1}' | xargs git show
