#!/bin/bash

alias ri='source ~/.init/init.sh'

# git
alias g1='git reset $(git commit-tree "HEAD^{tree}" -m "A new start")'

# rsync
alias rs='rsync --rsync-path="sudo rsync" -avzhe ssh'

# serve static files
alias ss='python -m http.server 8000 -d'

# download youtube mp3
alias yt='yt-dlp -x --audio-format mp3'
