#!/usr/bin/zsh

if [[ $# -eq 1 ]]; then
	selected=$1
else
  # tr -s ' ' squeezes the whitespace
  local bookmarks=$(bls | tr -s ' ' | cut -f3 -d ' ')
  local commonDirectories=$(find ~/work/configurator ~/personal ~/open-source -mindepth 1 -maxdepth 1 -type d 2> /dev/null
)

  selected=$({echo "$bookmarks"; echo "$commonDirectories"; } | fzf)
  
fi

if [[ -z $selected ]]; then
	exit 0
fi


if [[ $selected = '.' ]]; then
  selected=$(pwd)
elif [[ $selected = '..' ]]; then
  selected=$(dirname $(pwd))
fi

session_name=$(basename "$selected" | tr . _)

not_in_tmux() {
	[ -z "$TMUX"]
}

tmux_not_running() {
	[[ -z $tmux_running ]]
}

session_exists() {
	# checks if the $session_name exists
	tmux has-session -t "=$session_name" 2>/dev/null
}

tmux_running=$(pgrep tmux)

if not_in_tmux && tmux_not_running; then
	tmux new-session -s $session_name -c $selected
	exit 0
fi

if ! session_exists; then
	# creating detached session
	tmux new-session -ds $session_name -c $selected
fi

if not_in_tmux; then
  tmux attach-session -t $session_name
else
  tmux switch-client -t $session_name
fi


