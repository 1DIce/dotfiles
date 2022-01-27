#!/bin/bash

run_update() {
  "$gitRoot/merlin-ng-libs/build.sh" build
  git rev-parse HEAD >> "$gitRoot/merlin-ng-libs/.lastBuild.info"
}

gitRoot=$(git rev-parse --show-toplevel)

## TODO error handling if file does not exist?
lastUpdatedForCommit=$(cat "$gitRoot/merlin-ng-libs/.lastBuild.info")
# if not commit id exists 

if [ -n "$lastUpdatedForCommit" ] 
then
  diffSinceLastUpdate=$(git diff  --name-only "$lastUpdatedForCommit"..HEAD -- "$gitRoot/merlin-ng-libs/")
  # if diff exists update
  if [ -n "$diffSinceLastUpdate" ]
  then
    run_update
  fi
else
  run_update
fi

exit 0


# run npm i in m.sales. Is that needed?




