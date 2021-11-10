#!/usr/bin/env bash

./scripts/generate-variables-md.sh > "/tmp/VARIABLES.md"

if cmp -s "VARIABLES.md" "/tmp/VARIABLES.md"; then
    echo "VARIABLES.md unchanged"
else
    echo "regenerated VARIABLES.md..."
    if [[ -n "$PR_BRANCH" ]]; then
        git fetch
        git checkout "$PR_BRANCH"
        git pull origin "$PR_BRANCH"
    fi
    echo "commiting..."
    mv "/tmp/VARIABLES.md" "VARIABLES.md"
    git add "VARIABLES.md"
    git commit -m "updating VARIABLES.md"
    echo "pushing..."

    if [[ -n "$PR_BRANCH" ]]; then
        git push origin $PR_BRANCH
    else
        git push
    fi
fi
