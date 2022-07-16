#!/usr/bin/env bash

function stripOrigin() {
  sed 's|^origin/||'
}

function findMatchingRemoteBranch(){
  local REQUESTED_BRANCH=$(echo "$1" | stripOrigin)
  local SEARCH_RESULT=$(git branch --remote --format='%(refname:lstrip=2)' \
    | stripOrigin \
    | grep --color=never --line-regexp --fixed-strings "$REQUESTED_BRANCH")

  echo "$SEARCH_RESULT"
}

[ -z "$1" ] && echo "ERROR: no worktree name or remote branch given" && exit 0


# check if the user input is an existing remote branch
INPUT_REMOTE_BRANCH=$(findMatchingRemoteBranch "$1")
if [ -z "$INPUT_REMOTE_BRANCH" ]; then
  BRANCH_NAME="feature/lars/$1"
  WORKTREE_DIR_NAME=$1
else
  BRANCH_NAME=$INPUT_REMOTE_BRANCH
  WORKTREE_DIR_NAME=$(echo "$INPUT_REMOTE_BRANCH" | sed 's|feature/||' | sed 's|/|_|g')
fi

WORKTREE_ROOT_DIR=$(find_up.sh . -type f -iname ".worktree.root" -execdir pwd \; | head -n 1)

[ -z "$WORKTREE_ROOT_DIR" ] && echo "ERROR: No '.worktree.root' file found!" && exit 0

WORKTREE_MAIN=$(cat "$WORKTREE_ROOT_DIR/.worktree.root" | grep 'main_dir=.*' | cut -f2 -d=)

[ -z "$WORKTREE_MAIN" ] && echo "ERROR: No 'main_dir' entry found!" && exit 0

pushd "$WORKTREE_ROOT_DIR/$WORKTREE_MAIN"

# git worktree add --track -b <branch> <path> <remote>/<branch>
git worktree add "../$WORKTREE_DIR_NAME" -b "$BRANCH_NAME"

# TODO i need a way to set the base branch: master lts/10.0 or lts/10.10

popd
exit 1




