#!/usr/bin/env bash
# print out all objects that ever existed in a git repo
# pipe it into grep to search for things
{
  find .git/objects/pack/ -name "*.idx" | while read i; do git show-index <"$i" | awk '{print $2}'; done
  find .git/objects/ -type f | grep -v '/pack/' | awk -F'/' '{print $(NF-1)$NF}'
} | while read o; do git cat-file -p $o; done
