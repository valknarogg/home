#!/usr/bin/env bash

git init
git stash
git remote add origin ssh://git@code.pivoine.art:2222/valknar/kompose.git
git fetch && git reset --hard origin/main
git stash pop
git add -A
git commit -m "$1"
git push -u origin main
rm -rf .git
