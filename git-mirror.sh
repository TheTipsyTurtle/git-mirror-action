#!/bin/sh

set -e

SOURCE_REPO=$1
DESTINATION_REPO=$2

GIT_SSH_COMMAND="ssh -v"

echo "SOURCE=$SOURCE_REPO"
echo "DESTINATION=$DESTINATION_REPO"

git clone --bare "$SOURCE_REPO" && cd `dirname "$SOURCE_REPO"`
echo "CLEANUP STARTED"
# Cleaning
git checkout master
git rm -r .github
git commit -m "cleaning directory"
git push origin master

git remote set-url --push origin "$DESTINATION_REPO"
git fetch -p origin
# Exclude refs created by GitHub for pull request.
git for-each-ref --format 'delete %(refname)' refs/pull | git update-ref --stdin
git push --mirror


