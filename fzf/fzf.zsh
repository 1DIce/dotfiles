# Setup fzf
# ---------
if [[ ! "$PATH" == */home/lars/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/lars/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/lars/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/lars/.fzf/shell/key-bindings.zsh"
