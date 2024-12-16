#!/usr/bin/env bash
# Use KDIff as mergetool for git in cygwin.
#   git config --global mergetool.kd.cmd "kdiff-merge.sh \"\$LOCAL\" \"\$REMOTE\" \"\$BASE\" \"\$MERGED\""
#   git config --global mergetool.kd.trustExitCode false
#   git mergetool -t kd branch1..branch2

local=$1
remote=$2
base=$3
merged=$4

UNAME=$(uname | tr "[:upper:]" "[:lower:]")

if grep -q WSL2 /proc/version; then
  /mnt/c/Program\ Files/KDiff3/kdiff3.exe "$base" "$local" "$remote" -L1 base -L2 local -L3 remote -o "$merged"
elif [ "$UNAME" == "linux" ]; then
  # is normal linux not wsl
  kdiff3 "$base" "$local" "$remote" -L1 base -L2 local -L3 remote -o "$merged"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # is normal linux not wsl
  kdiff3 "$base" "$local" "$remote" -L1 base -L2 local -L3 remote -o "$merged"
else
  /C/Program\ Files/KDiff3/kdiff3.exe "$base" "$local" "$remote" -L1 base -L2 local -L3 remote -o "$merged"
fi
