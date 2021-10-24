# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
setopt autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lars/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# aliases
alias l="ls -l"       # List in long format, exclude dotfiles
alias la="ls -la"      # List in long format, include dotfiles
alias ld="ls -ld */"   # List in long format, only directories
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Make Tab autocomplete regardless of filename case
set completion-ignore-case on 
# List all matches in case multiple possible completions are possible
set show-all-if-ambiguous on

# Set PATH
export PATH=~/bin:$PATH
export PATH=~/.local/bin:$PATH

# Default editor   
export EDITOR=nvim

# Go Lang installation
export PATH=$PATH:/usr/local/go/bin

export PATH=$PATH:~/go/bin

# Syntax highlight for less (the pages). "sudo apt install source-highlight" to use it
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R'

# xserver if running on wsl2
if grep -q WSL2 /proc/version; then
  export DISPLAY=$(route.exe print | grep 0.0.0.0 | head -1 | awk '{print $4}'):0.0
  export LIBGL_ALWAYS_INDIRECT=1

  alias docker="sudo podman"
  alias docker-compose="sudo podman-compose"
fi

# ripgrep for fzf if available
if type rg &> /dev/null; then 
  export FZF_DEFAULT_COMMAND='rg --files'
fi
# FZF terminal history search. trigger it with CRTL+r 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
