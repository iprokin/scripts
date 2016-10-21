#!/bin/sh
feh -Gd -B white --geometry 500x500 $2 --start-at "$1" "$(dirname "$1")"
