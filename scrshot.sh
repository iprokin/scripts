#!/bin/sh
timestamp="$(date +%Y%m%d%H%M%S)"
targetbase="$HOME/Documents"
[ -d $targetbase ] || exit 1
#scrot -s $targetbase/$timestamp.png
gm import $targetbase/$timestamp.png
