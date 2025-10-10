#!/bin/bash

TMP_PROJECT="$3"

git config --global user.email "valknar@pivoine.art"
git config --global user.name "Sebastian Krüger"

mkdir
git clone "$1" "$TMP_PROJECT"
cp -rf ./* "$TMP_PROJECT"
cd "$TMP_PROJECT"
rm -rf ./.env **/uploads/ ./**/*.sql ./**/*.pem
git add -A
git commit -m "$2"
git push
cd -
