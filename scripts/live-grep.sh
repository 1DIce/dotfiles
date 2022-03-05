#!/usr/bin/zsh

# Two-phase filtering with Ripgrep and fzf
# source: https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-to-fzf-only-search-mode
#
# 1. Search for text in files using Ripgrep
# 2. Interactively restart Ripgrep with reload action
#    * Press alt-enter to switch to fzf-only filtering
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="${*:-}"
IFS=: read -ra selected < <(
	FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
		fzf --ansi \
		--color "hl:-1:underline,hl+:-1:underline:reverse" \
		--disabled --query "$INITIAL_QUERY" \
		--bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
		--bind "alt-enter:unbind(change,alt-enter)+change-prompt(2. fzf> )+enable-search+clear-query" \
		--prompt '1. ripgrep> ' \
		--delimiter : \
		--preview 'bat --color=always {1} --highlight-line {2}' \
		--preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
)
# [ -n "${selected[0]}" ] && vim "${selected[0]}" "+${selected[1]}"
echo "${selected[0]}"
