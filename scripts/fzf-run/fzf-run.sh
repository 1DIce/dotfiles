#!/usr/bin/env sh
CONFIG_PATH="${HOME}/.config/fzf-run/fzf-run.json"

COMMANDS=$(cat "${CONFIG_PATH}" | jq -r '.commands | .[] | [.cmd, .description, (.keepPopupOpen // false) ] | @tsv')

SELECTED=$(echo "${COMMANDS}" | fzf --delimiter="\t" --with-nth="2" --prompt="fzf-run: ")

SELECTED_CMD=$(echo "${SELECTED}" | cut -f1)

eval "${SELECTED_CMD}"

KEEP_POPUP_OPEN=$(echo "${SELECTED}" | cut -f3)
if [ "$KEEP_POPUP_OPEN" = 'false' ]; then
	tmux display-popup -C
fi
