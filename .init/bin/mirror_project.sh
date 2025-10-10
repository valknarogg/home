#!/bin/bash

TMP_PROJECT="$PWD"
RELATIVE_HOME="$TMP_PROJECT"
CURRENT_PROJECT="${s##*/}"

cp -rf $RELATIVE_HOME/Projects/kompose/* $TMP_PROJECT
rm -rf $TMP_PROJECT/.env $TMP_PROJECT/**/uploads/ $TMP_PROJECT/**/*.sql $TMP_PROJECT/**/*.pem

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
