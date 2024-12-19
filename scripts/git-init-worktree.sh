#!/usr/bin/env bash

repo_url="$1"

if [ -z "$repo_url" ];then
  echo "No repo url given"
  exit 1
fi

repo_name=$(echo "$repo_name" | grep --only-matching '[^,]*$'} | sed 's/.git$//')

default_branch=$(git remote show "$repo_url" | sed -n '/HEAD branch/s/.*: //p')

default_branch_dir=$($(echo "$default_branch" | sed 's|/|_|g'))

mkdir repo_name
cd repo_name || exit 1

git clone "$repo_url" "./$default_branch_dir"

echo "default_branch_prefix=feature/lars/" > .worktree.root
echo "main_dir=$default_branch_dir" >> .worktree.root

echo "gitdir: ./$default_branch_dir" > .git
