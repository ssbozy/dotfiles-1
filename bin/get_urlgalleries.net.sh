#!/usr/bin/env bash

set -o nounset # error when referencing unset variables
set -o pipefail # don't just check the result of the last command

function print_red() {
    echo -e "\033[0;31m$1\033[0m"
}

if [[ -z "${2-}" ]]; then
    print_red "Specify URL and name"
    exit
fi

if [[ ! -e ~/Downloads/complete/\!4/wget/ ]]; then
  echo "Making directory"
  mkdir -p ~/Downloads/complete/\!4/wget/
fi

if [[ ${1:0:5} == "http:" ]]; then
    URL="$1"
    NAME="${2-}"
else
    URL="${2-}"
    NAME="$1"
fi

DESTINATION=$HOME/Downloads/complete/\!4/wget/$NAME
mkdir -p "$DESTINATION"
cd "$DESTINATION"

SUBDOMAIN=$(echo $URL | grep -Eo "http://[^/]+")

LINES=$(curl --silent $URL | grep -Eo "<a href='/image.php[^']+" | grep -Eo "/image.php.*")

for LINE in $LINES; do
    IFRAME=$(curl --silent --location "${SUBDOMAIN}${LINE}" | grep redirect | grep -Eo "src='[^']+" | grep -Eo "http.*")
    IFRAME_SUBDOMAIN=$(echo $IFRAME | grep -Eo "http://[^/]+")
    IMAGE_SRC=$(curl --silent $IFRAME | grep -Eo 'SRC="[^"]+')
    IMAGE_PATH=${IMAGE_SRC:5}
    IMAGE_FILENAME=$(echo $IMAGE_PATH | grep -Eo "/[^/]+$")
    echo "Downloading ${IFRAME_SUBDOMAIN}/${IMAGE_PATH} to ${IMAGE_FILENAME}"
    wget -nv ${IFRAME_SUBDOMAIN}/${IMAGE_PATH} -O ${IMAGE_FILENAME:1}
done