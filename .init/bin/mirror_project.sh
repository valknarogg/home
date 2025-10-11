#!/bin/bash

TMP_PROJECT="$PWD"
CURRENT_PROJECT="$TMP_PROJECT"
RELATIVE_HOME="${CURRENT_PROJECT##*/}"
ABSOLUTE_HOME="${RELATIVE_HOME}/home"

cp -rf $ABSOLUTE_HOME/* $CURRENT_PROJECT
rm -rf $CURRENT_PROJECT/.env $CURRENT_PROJECT/**/uploads/ $CURRENT_PROJECT/**/*.sql $CURRENT_PROJECT/**/*.pem
git add -A

if [[ `git add -A && git diff --quiet && git diff --cached --quiet` ]]; then
  # Changes
  echo "CHANGES in ${CURRENT_PROJECT} - Mirroring..."
  git commit -m "$1"
  git push
else
  # No changes
  echo "NO CHANGES in ${CURRENT_PROJECT} - Aborting..."
  git reset
  echo "EXIT"
  exit 0
fi
