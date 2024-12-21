#!/usr/bin/env bash

repo_url="$1"

if [ -z "$repo_url" ];then
  echo "No repo url given"
  exit 1
fi

repo_name=$(echo "$repo_url" | grep --only-matching '[^/]*$' | sed 's/.git$//')


mkdir "$repo_name"
cd "$repo_name" || exit 1

git clone "$repo_url" "./temp_main_branch"

temp_branch_dir='temp_main_branch'
pushd "$temp_branch_dir" &> /dev/null
default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
popd &> /dev/null

default_branch_dir=$(echo "$default_branch" | sed 's|/|_|g')

echo "Renaming $temp_branch_dir to $default_branch_dir"

mv ./"$temp_branch_dir" ./"$default_branch_dir"

echo "default_branch_prefix=feature/lars/" > .worktree.root
echo "main_dir=$default_branch_dir" >> .worktree.root

echo "gitdir: ./$default_branch_dir/.git" > .git
