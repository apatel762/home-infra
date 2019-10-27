#!/bin/bash

TOR_FILE=$HOME/Documents/tor-browser_en-US/start-tor-browser.desktop

DIR=${TOR_FILE%/*}
FILE=${TOR_FILE##*/}

if [[ -f $TOR_FILE ]]; then
  (pushd $DIR && ./$FILE; popd)
else
  >&2 echo "Could not find: $FILE"
  exit 1
fi
