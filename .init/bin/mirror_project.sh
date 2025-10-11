#!/bin/bash

TMP_PROJECT="$PWD"
CURRENT_PROJECT="$TMP_PROJECT"
ABSOLUTE_HOME=${CURRENT_PROJECT/kompose/"home"}

cp -rf $ABSOLUTE_HOME/Projects/kompose/* $CURRENT_PROJECT
rm -rf $CURRENT_PROJECT/.env $CURRENT_PROJECT/**/uploads/ $CURRENT_PROJECT/**/*.sql $CURRENT_PROJECT/**/*.pem
git add -A

if [ `git diff --quiet` = ""]; then
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
