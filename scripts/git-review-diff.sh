#!/bin/sh

# example options master, lts/10.10, origin/master
BASE_BRANCH=$1
SKIP_FROM_MERGE_BASE=$2
LOG_SIZE=500

echo "base branch: $BASE_BRANCH" >&2
echo "skip from merge-base: $SKIP_FROM_MERGE_BASE" >&2

MERGE_BASE=$(git merge-base $BASE_BRANCH HEAD)

GIT_LOG=$(git log --pretty=oneline -n $LOG_SIZE)

MERGE_BASE_LINE_NUMBER=$(echo "$GIT_LOG" | grep -n $MERGE_BASE | cut -f1 -d:)


COMPARE_AGAINST_LINE_NUMBER=$((MERGE_BASE_LINE_NUMBER - SKIP_FROM_MERGE_BASE))

# skipping commits
COMPARE_AGAINST=$(echo "$GIT_LOG" | sed -n ''"$COMPARE_AGAINST_LINE_NUMBER"'p' | cut -f1 -d ' ')

git diff $COMPARE_AGAINST..HEAD



