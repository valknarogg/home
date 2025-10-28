#!/bin/bash


is_ssh() {
  IS_SSH=$(cat /proc/$PPID/status | head -1 | cut -f2)
  if [ "$_IS_SSH" = "sshd-session" ]; then
    return 1
  else
    return 0
  fi
}

_home_push() {
  git add -A
  git commit -m "${1:-$CHORE_CHORE}"
  git push $2 $3
}

_home_pull() {
  [ -n $(is_ssh) ] && git checkout $HOME/.last_pwd
  git stash
  git pull $1 $2
  git stash pop
}

_site_deploy_jekyll() {
  cd "$HOME/repos/$1"
  rm -rf _site
  JEKYLL_ENV=production bundle exec jekyll build
  rsync -avzhe ssh _site/ "pi@hive:$DOCKER_STORAGE_DIR/staticwebserver/hosts/$1/" --delete
  cd -
}

_site_deploy_nuxt() {
  cd "$HOME/repos/$1"
  rm -rf .output
  npm run generate
  rsync -avzhe ssh .output/public/ "pi@hive:$DOCKER_STORAGE_DIR/staticwebserver/hosts/$1/" --delete
  cd -
}

_site_deploy_static() {
  cd "$HOME/repos/$1"
  rsync -avzhe ssh src/ "pi@hive:$DOCKER_STORAGE_DIR/staticwebserver/hosts/$1/" --delete
  cd -
}

_site_run_jekyll() {
  cd "$HOME/repos/$1"
  bundle exec jekyll serve --livereload
  cd -
}

_site_run_nuxt() {
  cd "$HOME/repos/$1"
  npm run dev
  cd -
}

_site_run_static() {
  cd "$HOME/repos/$1"
  python -m http.server 8000 -d src
  cd -
}

batch_file_sequence() {
  a=0
  for i in *.$2; do
    new=$(printf "$1-%03d.$2" "$a")
    mv -i -- "$i" "$new"
    let a="$a+1"
  done
}

batch_image_webp() {
  find . -type f -regex ".*\.\(jpg\|jpeg\|png\)" -exec mogrify -format webp {}  \; -print
  find . -type f -regex ".*\.\(jpg\|jpeg\|png\)" -exec rm {}  \; -print
}

batch_video_x264() {
  find . -type f -regex ".*\.\(mp4\)" -exec ffmpeg -i {} -vcodec libx264 -crf 24 "{}.mp4"  \; -print
  find . -type f -regex ".+mp4\.mp4" -exec python3 -c "import os;os.rename('{}', '{}'[:-4])"   \; -print
}

_image_description() {
  identify -verbose $1 | grep ImageDescription | sed "s/    exif:ImageDescription: //"
}

_image_optimize() {
  i_x4 && cp -rf x4/* . && i_x05 && cp -rf x05/* . && _file_sequence $1 webp && mv $1-000.webp $1.webp
  _image_description *.png
  rm -rf *.png x4 x05
}

_video_optimize() {
  filename=$(basename -- "$1")
  extension="${filename##*.}"
  filename="${filename%.*}"
  ffmpeg -y -i $1 -vf "setpts=1.25*PTS" -r 24 "$filename.mp4"
}

function _over_subdirs {
  _PWD=$PWD
  . $PWD/.env
  for D in $(find . -mindepth 1 -maxdepth 1 -type d); do
      cd "$D" && $1
      cd $_PWD
  done
}

_join_by() {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}
