#!/usr/bin/env bash

git="$1"

if [ -z "$git" ]; then
    # shellcheck disable=2016
    echo 'No github repository name given "https://github/$name"'
    exit
fi

tag=$(curl "https://api.github.com/repos/$git/releases/latest" | grep "tag_name" | cut -d'"' -f4)

echo "$tag"
