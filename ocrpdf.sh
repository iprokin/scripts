#!/bin/sh

# OCR pdf to searcheable pdf
# depends on sh, tesseract and graphicmagick
LANG="eng"
DENSITY=300
#TMPOUT="/tmp/tesseracttmp" # tesseract will add .pdf ext
tif=$(echo "$1" | sed 's/\.pdf$/\.tif/i')

gm convert -density $DENSITY "$1" "$tif"
if [ "$2" = "" ]; then
    # replace
    tesseract -psm 1 -l $LANG "$tif" "${1%.*}" pdf
else
    tesseract -psm 1 -l $LANG "$tif" "$2" pdf
fi
#tesseract $tif stdout
rm "$tif"
