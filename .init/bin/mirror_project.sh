#!/bin/bash

TMP_PROJECT="$PWD"
RELATIVE_HOME="$TMP_PROJECT"
CURRENT_PROJECT="${s##*/}"

if [[ `git status --porcelain --untracked-files=no` ]]; then
  # Changes
  cp -rf $RELATIVE_HOME/Projects/kompose/* $TMP_PROJECT
  rm -rf $TMP_PROJECT/.env $TMP_PROJECT/**/uploads/ $TMP_PROJECT/**/*.sql $TMP_PROJECT/**/*.pem
  git add -A
  git commit -m "$1"
  git push
else
  # No changes
  echo "no changes to latest posts"
  exit 0
fi
