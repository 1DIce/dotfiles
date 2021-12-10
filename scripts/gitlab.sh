#!/bin/bash
set -e

draft() {
  # check if remote is tracked?

  MR_EXISTS=

  TARGET_BRANCH= echo "master\nlts/10.0\n/lts/10.10" | fzf


  # check if mr already exists?

  glab mr create --assignee=@me --fill --draft --label team-ruby

}

# publish() {
#
# }
#
# trigger() { 
#
# }
#
# comment() { }

reviewer() {
 cat ~/.gitlab-usernames.txt | fzf | xargs  glab mr update --reviewer 
}

if [ "$1" == "draft" ]; then
 # todo target branch 
  draft
elif [ "$1" == "publish" ]; then
  publish
elif [ "$1" == "trigger" ]; then
  trigger
elif [ "$1" == "comment" ]; then
  comment
elif [ "$1" == "reviewer" ]; then
  reviewer
else
	echo "missing command, one of: draft, publish, trigger, comment, reviewer"
	exit 1
fi
