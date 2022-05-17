#! /usr/bin/env bash

GIT_ROOT=$(git rev-parse --show-toplevel)

find $GIT_ROOT \
	-iname '*.sh' \
	-not -path '**/node_modules/**' \
	-not -path 'build/scripts/git-all-executable.sh' \
	-exec git update-index --add --chmod=+x {} \;
