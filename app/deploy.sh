#!/bin/bash
repo=git@codeup.aliyun.com:61b175c645bcdc5071135609/Garden/garden_webservice.git
dir=releases/$(date +%Y%m%d%H%M%S)
shared=shared
uploads=$shared/uploads
config=$shared/config
env=$config/.env

makefile() {
  path=$1
  mf=makefile
  mf_path="$path"/$mf
  cp -f ${mf}.in "$mf_path"

  if [ "$2" == "prod" ]; then
    dev="--no-dev"
  fi

  uname=$(uname -v)
  os=${uname:0:6}
  case ${os} in
  'Darwin')
    sed -i '' "s/%dev%/$dev/g" "$mf_path"
    sed -i '' 's/%webuser%/staff/g' "$mf_path"
    ;;
  *)
    sed -i "s/%dev%/$dev/g" "$mf_path"
    sed -i 's/%webuser%/www-data/g' "$mf_path"
    ;;
  esac
  return 0
}

# git
git clone -b dev  $repo "$dir" || exit 1

# makefile
case $1 in
  'dev')
    makefile "$dir" dev
    ;;
  *)
    makefile "$dir" prod
    ;;
esac

# env
if [ ! -f $env ]; then
  touch $env
fi

(cd "$dir" || exit;ln -sf ../../shared/config/.env .env)
(cd "$dir" || exit;ln -sf ../../$env .env)

# uploads
chown -R www-data:www-data $uploads
(cd "$dir/public" || exit;ln -sf ../../../$uploads uploads)

# make
#(cd "$dir" && make) || exit 1

# current link
(rm -rf current && ln -sf "$dir" current)

# logs link
# (rm -rf logs && ln -sf "$dir"/storage/logs logs)
