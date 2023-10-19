#!/usr/bin/env bash
SCRIPT_DIR=${0%/*}
PROJECT_DIR=$SCRIPT_DIR/../

## to make script abort, when any command fails
set -e
set -o pipefail


printf "\n[[run simple role tests]]\n"
find "$PROJECT_DIR/roles" -mindepth 1 -maxdepth 1 -type d -print0 |
    while IFS= read -r -d '' line; do
        role=$(echo "$line" | sed -E 's$.*/([^/]+)$\1$')
        printf "\n[run tests of role: '%s']\n\n" "$role"
        "$SCRIPT_DIR/test_role.sh" "$role" "$1"
    done

printf "\n[[run combination tests]]\n"
# execute all "test.sh" in subdirs (set '-mindepth 2' to avoid recursion)
find "$SCRIPT_DIR/" -mindepth 2 -type f -name test.sh -print0 |
    while IFS= read -r -d '' line; do
        bash "$line" "$1"
    done
