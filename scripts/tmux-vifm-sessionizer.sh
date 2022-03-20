#! /usr/bin/env zsh

vifm --choose-dir - | xargs tmux-sessionizer
