#!/bin/bash

if command -v oh-my-posh 2>&1 >/dev/null; then
  eval "$(! oh-my-posh init zsh --config=~/worker.omp.json)"
fi

if command -v rbenv 2>&1 >/dev/null; then
  eval "$(rbenv init - --no-rehash zsh)"
fi

if command -v pyenv 2>&1 >/dev/null; then
  eval "$(pyenv init --path)"
fi