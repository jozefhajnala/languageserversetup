#!/bin/sh

# Example non-Linux platforms:
#  "macos-elcapitan-release"
#  "windows-x86_64-devel"

set -e

platform=$1
container_name=languageserversetup_check
image_name=index.docker.io/jozefhajnala/rhub:latest
script_dir=$(dirname $(readlink -f "$0"))
dir_root=$script_dir/../

docker login --username jozefhajnala --password $DOCKER_LOGIN_TOKEN
docker pull $image_name

docker run -i -d \
  --name $container_name \
  $image_name bash

docker cp $dir_root $container_name:/root

docker exec \
  --workdir /root/languageserversetup \
  $container_name \
  Rscript inst/rhubcheck.R $platform

docker stop $container_name
docker rm $container_name
