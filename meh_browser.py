#!/usr/bin/env python3

# meh-browser
# Copyright Ilya Prokin 2016

# A simple wrapper script to show an image in meh and continue browsing other images in the same folder
#
# Optionally depends on
# notify-send
# and
# xclip
# to show notification with filename and to copy filename to clipbaord when hitting Enter on an image.

import sys
import os
import subprocess
import re

fexts = '\.jpg$|\.jpeg$|\.bmp$|\.png$|\.pbm$' # formats to open

command = 'meh {0} | while read -r line; do notify-send "$line"; echo -n "$line" | xclip -selection c; done'
#command = 'meh {0}'

if __name__ == '__main__':
    if len(sys.argv)>1:
        d = os.path.dirname(sys.argv[1])
        if d=='':
            d='./'
        f = os.path.basename(sys.argv[1])
        os.chdir(d)
        l = os.listdir(d)
        l = sorted(list(filter(lambda x: re.search(fexts, x , flags=re.IGNORECASE), l)))
        i = l.index(f)
        l = l[i:]+l[:i]
        l = map(lambda s: "'{0}'".format(os.path.join(os.path.abspath(d), s)), l)
        cmd = command.format(' '.join(l))
        subprocess.call(cmd, shell=True)
