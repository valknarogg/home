#!/bin/bash

TMP_PROJECT="$PWD"
CURRENT_PROJECT="$TMP_PROJECT"
RELATIVE_HOME="${CURRENT_PROJECT##*/}"
ABSOLUTE_HOME="${RELATIVE_HOME}/home"

cp -rf $ABSOLUTE_HOME/Projects/kompose/* $CURRENT_PROJECT
rm -rf $CURRENT_PROJECT/.env $CURRENT_PROJECT/**/uploads/ $CURRENT_PROJECT/**/*.sql $CURRENT_PROJECT/**/*.pem

if [[ `git add -A && git diff --quiet && git diff --cached --quiet` ]]; then
  # Changes
  git commit -m "$1"
  git push
else
  # No changes
  git reset
  echo "no changes to latest posts"
  exit 0
fi
