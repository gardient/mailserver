#!/usr/bin/env bash

GH_TOKEN="$1"
./scripts/generate-variables-md.sh > "/tmp/VARIABLES.md"

if cmp -s "VARIABLES.md" "/tmp/VARIABLES.md"; then
    echo "VARIABLES.md unchanged"
else
    echo "regenerated VARIABLES.md..."
    echo "commiting..."
    mv "/tmp/VARIABLES.md" "VARIABLES.md"
    git add "VARIABLES.md"
    git commit -m "updating VARIABLES.md"
    echo "pushing..."
    git push
fi
