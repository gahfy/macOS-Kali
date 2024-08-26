#!/bin/zsh

SOFTWARES_DIR="${SOFTWARES_DIR:-$HOME/.softwares}"

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Usage: $0 <url> <file_name> <sha-512-hash>" && \
  exit 1
fi && \
url=$1 && \
file_name=$2 && \
expectedsha512=$3 && \
filepath="$SOFTWARES_DIR/sources/$file_name" && \
if [ -f "$filepath" ]; then
  actualsha512=$(shasum -a 512 $filepath | awk '{print $1}') && \
  if [[ "$expectedsha512" == "$actualsha512" ]]; then
    echo "File $filepath exists and its SHA-512 hash matches the expected one" && \
    exit 0
  else
    echo "File $filepath exists but its SHA-512 hash differs from the expected one" && \
    echo "Removing it and downloading it" && \
    rm $filepath
  fi
fi && \
for tries in {1..3}
do
  echo "Start downloading $url"
  curl -Ls "$url" -o $filepath
  if [ -f "$filepath" ]; then
    actualsha512=$(shasum -a 512 $filepath | awk '{print $1}') && \
    if [[ "$expectedsha512" == "$actualsha512" ]]; then
      echo "Successfully downloaded $url" && \
      exit 0
    else
      echo "Downloaded $url but its SHA-512 hash differs from the expected one" && \
      if [[ "$tries" == "3" ]]; then
        echo "Removing file and ending program"
      else
        echo "Removing file and retrying"
      fi
      rm $filepath
    fi
  else
    echo "Failed to download $url"
    if [[ "$tries" == "3" ]]; then
      echo "Ending program in failure"
      exit 1
    else
      echo "Retrying"
    fi
  fi
done && \
exit 1