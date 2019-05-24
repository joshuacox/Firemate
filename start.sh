#!/bin/bash

MYCWD=$(pwd)
TZ=${TZ:-America/Chicago}
#export FIREFOX_BIN=/home/firefox/firefox/firefox
export FIREFOX_BIN=./firefox

cd $MYCWD
ls -alh

if [ -s /LINK ]; then
  nice -n $NICENESS $FIREFOX_BIN \
  --new-window \
  `cat /LINK`
else
  nice -n $NICENESS $FIREFOX_BIN \
  --new-window \
  'http://bokbot.org/'
fi
