#!/bin/bash
set -e

draft() {
  # check if remote is tracked?

  MR_EXISTS=true
  TRACKED_BRANCH_EXISTS=true
  TRACKED_BRANCH =$(git rev-parse --symbolic-full-name --abbrev-ref  HEAD@{u} | sed -e "s/^origin\///")
  if [ $? -ne 0]; then
    echo "Remote branch does not exist yet"
    MR_EXISTS=false
    TRACKED_BRANCH_EXISTS=false
  else
    MR_LIST=$(glab mr  list --source-branch="$TRACKED_BRANCH")
    if [$? -ne 0]; then
      echo "No merge request found for the tracked branch"
      MR_EXISTS=false
    else
      NUMBER_OF_MR=$(echo "$MR_LIST" | wc -l)
      if [$NUMBER_OF_MR -ne 1]; then
        echo "Error: More then one related Merge request was found"
        exit 1;
      fi
      MR_EXISTS=true
  fi


  if [$MR_EXISTS]; then 
    glab mr update --draft
    # TODO i need the --force flag for push
    git push
  else
    if[$TRACKED_BRANCH_EXISTS -e false]; then
      LOCAL_BRANCH_NAME=$(git rev-parse --symbolic-full-name --abbrev-ref  HEAD)
      git push --set-upstream origin "$LOCAL_BRANCH_NAME"
    fi
    TARGET_BRANCH=$(echo "master\nlts/10.0\n/lts/10.10" | fzf)
    glab mr create --assignee=@me --fill --draft --label team-ruby --target-banch"$TARGET_BRANCH"



  # check if mr already exists?


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
