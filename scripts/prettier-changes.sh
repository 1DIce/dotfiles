#!/bin/bash
# for a pre-commit hook it should be a sh script. That means pushd is not available
GIT_ROOT_DIR=$(git rev-parse --show-toplevel)

FILES=$(git diff --cached --name-only --diff-filter=ACMR | sed 's| |\\ |g' )
[ -z "$FILES" ] && exit 0

M_SALES_FILES=$(echo "$FILES" | grep '^m.sales.neo')

if [ ! -z "$M_SALES_FILES" ]
then
  pushd "$GIT_ROOT_DIR/m.sales.neo"
  # convert relative file paths to absolute paths
  M_SALES_FILES=$(echo "$M_SALES_FILES" | sed "s|^|$GIT_ROOT_DIR/|g")
  # Prettify all selected files
  echo "$M_SALES_FILES" | xargs npx prettier --ignore-unknown --write
  # Add back the modified/prettified files to staging
  echo "$M_SALES_FILES" | xargs git add
  popd
fi


exit 0
