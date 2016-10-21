#!/bin/sh
R=1
if [ $R -eq 1 ]; then
    redshift -o
    sed -i 's/^R=1$/R=0/' $0
else
    redshift -t 6400:6400 -o
    sleep 2s
    xcalib /home/ilya/.local/share/icc/color.icc
    sed -i 's/^R=0$/R=1/' $0
fi
