#!/bin/bash
set -e
path="$1"
shift 1
while [[ $path != / ]]; do
	find "$path" -maxdepth 1 -mindepth 1 "$@"
	# Note: if you want to ignore symlinks, use "$(realpath -s "$path"/..)"
	path="$(readlink -f "$path"/..)"
done

# find_up.sh . -iname ".gitconfig"
# ... will find all paths of .gitconfig file in parent directories

# usage: find_up.sh some_dir -iname "foo*bar" -execdir pwd \;
# ...will print the names of all of some_dir's ancestors (including itself) up to / in which a file with the pattern is found.


