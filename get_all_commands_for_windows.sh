#!/bin/sh

# lists all processes for all open windows
# comes handy when writing scripts for restoring windows layout in i3wm.
# Copyright Ilya Prokin 2016
# UIWYLIWAWWSE Licence: Use It Whatever You Like It Without Any Warranty What So Ever

WINS=$(xlsclients | awk '{print $2}')
PROCESSES=$(ps -aef)
for n in $WINS; do
    echo "$PROCESSES" | grep $n | sed 's/[ \t]\+/ /g' | cut -d' ' -f 8-
done | sort -u
