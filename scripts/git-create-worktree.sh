#!/bin/zsh


# feature/lars/some-task
# or lars/some-taks

# feature+some-task
# some+task
WORKTREE_DIR_NAME=$1

# baseBranch=$2

# if [ -z "$baseBranch"] && echo "ERROR: No base branch provided" && exit 0

BRANCH_NAME="feature/lars/$1"

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



