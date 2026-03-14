#!/usr/bin/env bash

# Set colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Checking git worktrees older than 30 days..."
echo "--------------------------------------------"

# Get current date in seconds since epoch
current_date=$(date +%s)
# 30 days in seconds
thirty_days=$((30 * 24 * 60 * 60))

worktree_paths=$(git worktree list | awk '{print $1}')

# Find all directories that are git repositories
for dir in $worktree_paths; do
        cd "$dir" || continue

        # Check if this is a git directory
        if git rev-parse --is-inside-work-tree &>/dev/null; then

            # find the last time anything changed in the directory. The output is the timestamp in iso format
            last_change_date=$(find . -type f -exec ls --full-time {} + | awk '{print $6"T"$7}' | sort -r | head -n1)
            # Get the last commit date in seconds since epoch
            last_commit_date=$(git log -1 --format="%at" 2>/dev/null)

            # If there are no commits yet, use directory creation time
            if [ -z "$last_commit_date" ]; then
                last_commit_date=$(stat -c %Y .)
            fi

            # Calculate age in days
            age_seconds=$((current_date - last_commit_date))
            age_days=$((age_seconds / 86400))

            # Check if older than 30 days
            if [ $age_seconds -gt $thirty_days ]; then
                echo -e "${YELLOW}Worktree: ${dir%/} (${age_days} days old)${NC}"

                # Check for uncommitted changes
                if ! git diff --quiet; then
                    echo -e "  ${RED}✗ Has uncommitted changes${NC}"
                else
                    echo -e "  ${GREEN}✓ No uncommitted changes${NC}"
                fi

                # Check for untracked files
                if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                    echo -e "  ${RED}✗ Has untracked files${NC}"
                else
                    echo -e "  ${GREEN}✓ No untracked files${NC}"
                fi

                echo ""
            fi
        fi
        cd ..
done

echo "Done!"
