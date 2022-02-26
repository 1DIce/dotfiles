#!/usr/bin/env bash


find . -type d -name 'node_modules' -prune | xargs du -sh | fzf --multi |  awk '{print $2}' | trash 

