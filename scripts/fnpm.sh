#!/usr/bin/env bash

# Fuzzy search and run "npm run" scripts

if cat package.json > /dev/null 2>&1; then
    scripts=$(cat package.json | jq .scripts | sed '1d;$d' | fzf --height 40%)

    if [[ -n $scripts ]]; then
        script_name=$(echo "$scripts" | awk -F ': ' '{gsub(/"/, "", $1); print $1}' | xargs)
        npm run "$script_name"
    else
        echo "Exit: You haven't selected any script"
    fi
else
    echo "Error: There's no package.json"
fi
